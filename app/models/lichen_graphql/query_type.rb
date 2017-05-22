module LichenGraphql

  query_types = ::LichenGraphql::Registry.query_types.compact

  QueryType = ::GraphQL::ObjectType.define do
    name "Query"
    description "The query root of this schema"
  end


  QueryType.fields = query_types.inject({}) do |accumulator, type|
    accumulator.merge!(type.fields)
  end

end
