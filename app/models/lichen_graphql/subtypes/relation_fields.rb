module LichenGraphql
  module Subtypes
    module RelationFields

      def add_relations_to_base_query_type
        return if included_reflections_for_query.empty?

        reflections = self.model.reflections.select do |key, reflection|
          self.included_reflections_for_query.include?(key.to_s)
        end
        return if reflections.empty?

        base_query_type = self.find_or_create_base_query_type

        # create fields based on the type's relations
        reflections.each do |key, reflection|
          relation_field = self.make_field_for_relation(key, reflection)
          base_query_type.fields[key.to_s] = relation_field
        end

      end

      def included_reflections_for_query
        self.model.reflections.keys - [
          'taggings',
          'base_tags',
          'tag_visible_taggings',
          'tag_invisible_taggings',
          'roles'
        ]
      end

      protected

        def make_field_for_relation(rel_name, rel)
          rel_type_name = "#{Utils.to_type_name(rel.klass.name)}BaseQuery"
          rel_type = ::LichenGraphql::TypeStore.registered_types[rel_type_name] ||
            ::LichenGraphql::DynamicType.new(rel.klass, {}).find_or_create_base_query_type
          field = ::GraphQL::Field.new
          field.name = rel_name.to_s
          if rel.collection?
            field.type = rel_type.to_list_type
          else
            field.type = rel_type
          end
          field
        end


    end
  end
end
