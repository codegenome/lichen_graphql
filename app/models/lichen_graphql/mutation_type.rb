module LichenGraphql

  mutation_types = ::LichenGraphql::Registry.mutation_types.compact

  MutationType = ::GraphQL::ObjectType.define do
    name "Mutation"
    description "The mutation root of this schema"

  end

  MutationType.fields = mutation_types.inject({}) do |accumulator, type|
    accumulator.merge!(type.fields)
  end

end
