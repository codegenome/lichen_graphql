module LichenGraphql
  module Utils

    def self.to_type_name(model_name)
      model_name.split('::').join('')
    end

    def self.find_base_query_type(modele)
      base_query_type_name = "#{to_type_name(modele.name)}BaseQuery"
      base_query_type = ::LichenGraphql::TypeStore.registered_types[base_query_type_name] ||
        ::LichenGraphql::DynamicType.new(modele, {}).find_or_create_base_query_type
    end

    def self.convert_type(database_type)
      scalar_types = {
        integer: ::GraphQL::INT_TYPE,
        float: ::GraphQL::FLOAT_TYPE,
        boolean: ::GraphQL::BOOLEAN_TYPE,
      }

      scalar_types[database_type.to_sym] || ::GraphQL::STRING_TYPE
    end

    def self.paginate(collection, limit, page, order_by = :id)
      page ||= 1
      limit ||= 25
      offset = (page - 1) * limit
      collection = collection.order(order_by).offset(offset).limit(limit)
    end

  end
end
