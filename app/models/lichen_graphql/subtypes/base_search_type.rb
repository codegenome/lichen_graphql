module LichenGraphql
  module Subtypes
    module BaseSearchType

      def create_base_search_type
        return nil if (self.included_search_columns.empty? && !block_given?)

        this = self

        base_search_type = ::GraphQL::InputObjectType.define do
          name "#{this.type_name}BaseSearch"
          description "Attributes that can be searched for #{this.field_name.pluralize}"

          columns = this.model.columns.select {|column| this.included_search_columns.include?(column.name) }
          columns.each do |column|
            argument column.name, Utils.convert_type(column.type)
          end

          # add more arguments here
          yield(self) if block_given?
        end
        base_search_type
      end

      def create_relation_search_type
        return nil if (self.included_search_relations.empty? && !block_given?)

        this = self

        relation_search_type = ::GraphQL::InputObjectType.define do
          name "#{this.type_name}RelationSearch"
          description "Relations that can be searched for #{this.field_name.pluralize}"

          this.included_search_relations.keys.each do |relation_name|
            argument relation_name, types.String
          end

          # add more arguments here
          yield(self) if block_given?
        end
        relation_search_type

      end

      def search_by_attrs_resolve(obj, args, ctx)
        result = self.model.none
        if args[:attrs].present?
          result = self.collection(ctx)

          like_attrs = [] # queried with LIKE
          eq_attrs = [] # queried with =

          args[:attrs].each_value  do |attr|
            next unless self.included_search_columns.include?(attr.key)
            (attr.definition.type == ::GraphQL::STRING_TYPE) ?
               like_attrs << attr.key :
               eq_attrs << attr.key
          end

          if like_attrs.present? || eq_attrs.present?
            bool_op = ' AND '
            query_str = [like_attrs.map {|attr| "unaccent(#{attr}) ILIKE ?"}.join(bool_op).presence,
              eq_attrs.map {|attr| "#{attr} = ?"}.join(bool_op).presence].compact.join(bool_op)

            all_args = like_attrs.map {|arg| "%#{args[:attrs][arg].downcase.parameterize('%')}%"} +
              eq_attrs.map {|arg| args[:attrs][arg] }

            result = result.where(query_str, *all_args)
          end
        end

        if args[:rels].present?
          vals = []
          query_string = []
          args[:rels].to_h.compact.each do |attr, val|
            if val.is_a?(String)
              vals.push("%#{val.downcase.parameterize('%')}%")
            else
              vals.push(val)
            end
            query_string.push(self.included_search_relations[attr.to_sym])
          end
          _collection = self.collection(ctx)
          args[:rels].to_h.each do |attr, val|
            _collection = _collection.joins(attr.to_sym)
          end
          _collection = _collection.where(query_string.join(' AND '), *vals)
          result = (result.any?) ? result.merge(_collection) : _collection
        end

        # refine search results, apply order, etc. here
        result = yield(result) if block_given?

        result
      end

      def search_by_q_resolve(obj, args, ctx)
        self.model.none
      end

      def included_search_columns
        []
      end

      def included_search_relations
        {}
      end



    end
  end
end
