Dir[File.dirname(__FILE__) + '/subtypes/*.rb'].each {|file| require file }

module LichenGraphql
  class DynamicType
    include Subtypes::BaseQueryType
    include Subtypes::BaseMutationType
    include Subtypes::BaseSearchType
    include Subtypes::RelationFields

    # [:create, :update, :destroy]
    MUTATION_TYPES_DEFAULT = []

    # [:index, :show]
    QUERY_TYPES_DEFAULT = [:index, :show]

    attr_accessor :model, :field_name, :type_name,
      :permission_class, :uuid_as_id, :query_string_search, :mutation_types, :query_types, :singleton

    def initialize(model_class, options={})
      options ||= {}

      @model = model_class

      # change access permissions to data here
      @permission_class = ::LichenGraphql::PermissionAssertion

      @field_name  = options.key?(:field_name) ? options[:field_name] : model_class.name.demodulize.underscore # ex: mot for Meta::Mot
      @type_name = Utils.to_type_name(model_class.name) # ex: MetaMot for Meta::Mot

      @uuid_as_id = options[:uuid_as_id] || model_class.columns.detect {|column| column.name == "uuid" }.present?
      @query_string_search = options.key?(:query_string_search) ? options[:query_string_search] : false
      @singleton = options.key?(:singleton) ? options[:singleton] : false

      @mutation_types = options.key?(:mutation_types) ? options[:mutation_types].to_a : MUTATION_TYPES_DEFAULT.dup
      @query_types = options.key?(:query_types) ? options[:query_types].to_a : QUERY_TYPES_DEFAULT.dup
      @query_types.delete(:index) if @singleton
    end

    def collection(context = {})
      self.model.all
    end

    def creator(context = {}, args)
      self.model.new(args)
    end

    def create_query_type
      return nil if [
        self.query_types,
        self.query_string_search,
        (base_search_type = self.create_base_search_type),
        (relation_search_type = self.create_relation_search_type),
      ].map(&:presence).compact.empty? && !block_given?

      this = self
      base_query_type = self.find_or_create_base_query_type
      query_type_name = self.type_name + 'Query'
      query_type = ::GraphQL::ObjectType.define do
        name query_type_name
        description "Query type from model #{this.model.name}"

        if this.query_types.include?(:index)
          field this.field_name.pluralize.to_sym do
            type types[base_query_type]
            argument :ids, (this.uuid_as_id ? types[types.String] : types[types.Int])
            argument :limit, types.Int
            argument :page, types.Int
            resolve this.permission_class.new(this, -> (obj, args, ctx) {
              if args[:ids]
                if this.uuid_as_id
                  resources = this.collection(ctx).where(uuid: args[:ids])
                else
                  resources = this.collection(ctx).where(id: args[:ids])
                end
              else
                resources = this.collection(ctx)
              end

              resources = Utils.paginate(resources, args[:limit], args[:page])
            })
          end
        end

        if this.query_types.include?(:show)
          field this.field_name.singularize.to_sym do
            type base_query_type
            argument :id, !(this.uuid_as_id ? types.String : types.Int) unless this.singleton
            resolve this.permission_class.new(this, ->(obj, args, ctx) {
              if this.singleton
                this.collection(ctx)
              elsif this.uuid_as_id
                this.collection(ctx).find_by(uuid: args[:id])
              else
                this.collection(ctx).find_by(id: args[:id])
              end
            })
          end
        end

        # search by attributes field
        if base_search_type || relation_search_type
          field "search_#{this.field_name.pluralize}_by".to_sym do
            type types[base_query_type]
            description "Search #{this.field_name.pluralize} by given attributes"
            argument :attrs, base_search_type if base_search_type.present?
            argument :rels, relation_search_type if relation_search_type.present?
            argument :limit, types.Int
            argument :page, types.Int
            resolve this.permission_class.new(this, -> (obj, args, ctx) {
              result = this.search_by_attrs_resolve(obj, args, ctx)
              result = Utils.paginate(result, args[:limit], args[:page])
            })
          end
        end

        # search by query string field
        if this.query_string_search
          field "search_#{this.field_name.pluralize}".to_sym do
            type types[base_query_type]
            description "Search #{this.field_name.pluralize} by a query string"
            argument :q, !types.String
            argument :limit, types.Int
            argument :page, types.Int
            resolve this.permission_class.new(this, -> (obj, args, ctx) {
              result = this.search_by_q_resolve(obj, args, ctx)
              result = Utils.paginate(result, args[:limit], args[:page])
            })
          end
        end

        # add more fields here
        yield(self, base_query_type) if block_given?

      end

      query_type
    end

    def create_mutation_type
      return nil if mutation_types.empty? && !block_given?

      base_mutation_type = self.find_or_create_base_mutation_type
      base_query_type = self.find_or_create_base_query_type
      mutation_type_name = self.type_name + 'Mutation'

      this = self
      mutation_type = ::GraphQL::ObjectType.define do
        name mutation_type_name
        description "Mutation type from model #{this.model.name}"

        if this.mutation_types.include?(:update)
          field "update_#{this.field_name.singularize}".to_sym do
            type base_query_type
            argument :id, !(this.uuid_as_id ? types.String : types.Int) unless this.singleton
            argument :attrs, base_mutation_type
            resolve this.permission_class.new(this, -> (obj, args, ctx) {
              if this.singleton
                resource = this.collection(ctx)
              elsif this.uuid_as_id
                resource = this.collection(ctx).find_by!(uuid: args[:id])
              else
                resource = this.collection(ctx).find(args[:id])
              end
              resource.update_attributes(args[:attrs].to_h)
              resource.reload
              resource
            })
          end
        end

        if this.mutation_types.include?(:create)
          field "create_#{this.field_name.singularize}".to_sym do
            type base_query_type
            argument :attrs, base_mutation_type
            resolve this.permission_class.new(this, -> (obj, args, ctx) {
              # resource = this.model.new(args[:attrs].to_h)
              resource = this.creator(ctx, args[:attrs].to_h)
              resource.save
              resource.reload
              resource
            })
          end
        end

        if this.mutation_types.include?(:destroy)
          field "destroy_#{this.field_name.singularize}".to_sym do
            type base_query_type
            argument :id, !(this.uuid_as_id ? types.String : types.Int)
            resolve this.permission_class.new(this, -> (obj, args, ctx) {
              if this.uuid_as_id
                resource = this.collection(ctx).find_by!(uuid: args[:id])
              else
                resource = this.collection(ctx).find(args[:id])
              end
              if resource.destroy
                resource
              else
                raise "Resource #{this.field_name.singularize} with id #{args[:id]} cannot be deleted."
              end
            })
          end
        end

        # add more fields here
        yield(self, base_query_type) if block_given?
      end

      mutation_type
    end



  end
end
