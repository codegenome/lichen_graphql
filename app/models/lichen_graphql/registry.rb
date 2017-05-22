module LichenGraphql
  module Registry

    QUERY_TYPES = []
    MUTATION_TYPES = []

    def self.query_types
      self.define_graphql_types if QUERY_TYPES.empty?
      QUERY_TYPES
    end

    def self.mutation_types
      self.define_graphql_types if MUTATION_TYPES.empty?
      MUTATION_TYPES
    end

    def self.define_graphql_types

      registered_types = ::RegisteredTypes.registered_types || []

      registered_type_instances = registered_types.map do |type|
        type.new
      end

      registered_type_instances.each do |type|
        type.create_base_query_type
        type.create_base_mutation_type
      end

      registered_type_instances.each do |type|
        type.add_relations_to_base_query_type
      end

      registered_type_instances.each do |type|
        if (_query_type = type.create_query_type).present?
          QUERY_TYPES.push(_query_type)
        end
        if (_mutation_type = type.create_mutation_type).present?
          MUTATION_TYPES.push(_mutation_type)
        end
      end

    end

  end
end
