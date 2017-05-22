module LichenGraphql
  module Subtypes
    module BaseQueryType

      def create_base_query_type
        this = self
        base_type_name = "#{this.type_name}BaseQuery"
        base_query_type = ::GraphQL::ObjectType.define do
          name base_type_name
          description "Base query type from model #{this.model.name}"

          columns = this.model.columns.select {|column| this.included_query_columns.include?(column.name) }

          columns.each do |column|
            if column.name == "id" and this.uuid_as_id
              field column.name, Utils.convert_type(:uuid) do
                resolve ->(obj, args, ctx) { obj.uuid }
              end
            else
              field column.name, Utils.convert_type(column.type)
            end
          end

          # add more fields in block
          yield(self) if block_given?
        end
        ::LichenGraphql::TypeStore.new(base_type_name, base_query_type)

        base_query_type
      end

      def find_or_create_base_query_type
        base_type_name = "#{self.type_name}BaseQuery"
        ::LichenGraphql::TypeStore.registered_types[base_type_name] || self.create_base_query_type
      end

      # columns that will be exposed for viewing
      def included_query_columns
        self.model.columns.map(&:name) - [
          'lft',
          'rgt',
        ] - (self.uuid_as_id ? ['uuid'] : [])
      end
    end
  end
end
