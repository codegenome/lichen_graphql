module LichenGraphql

query_types = ::LichenGraphql::QueryType if ::LichenGraphql::Registry.query_types.compact.any?
mutation_types = ::LichenGraphql::MutationType if ::LichenGraphql::Registry.mutation_types.compact.any?
resolve_type_proc = ::LichenGraphql::Registry.resolve_type_proc if ::LichenGraphql::Registry.respond_to?(:resolve_type_proc)

  Schema = ::GraphQL::Schema.define do
    if query_types
      query query_types
    end
    if mutation_types
      mutation mutation_types
    end
    resolve_type resolve_type_proc
  end

end
