module LichenGraphql
  module Subtypes
    module BaseMutationType

    def create_base_mutation_type

      this = self
      mutation_type_name = "#{this.type_name}BaseMutation"
      base_mutation_type = ::GraphQL::InputObjectType.define do
        name mutation_type_name
        description "Base mutation type from model #{this.model.name}"

        columns = this.model.columns.select {|column| this.included_mutation_columns.include?(column.name) }
        columns.each do |column|
          argument column.name, Utils.convert_type(column.type)
        end

        # add more arguments in block
        yield(self) if block_given?

      end

      ::LichenGraphql::TypeStore.new(mutation_type_name, base_mutation_type)
      mutation_type_name
    end

    def find_or_create_base_mutation_type
      mutation_type_name = "#{self.type_name}BaseMutation"
      ::LichenGraphql::TypeStore.registered_types[mutation_type_name] || self.create_base_mutation_type
    end

    # columns that will be exposed for changing (akin to 'permitted_params')
    def included_mutation_columns
      self.included_query_columns - [
        'id',
        'uuid',
        'created_at',
        'updated_at',
        'children_count'
      ]
    end

    end
  end
end
