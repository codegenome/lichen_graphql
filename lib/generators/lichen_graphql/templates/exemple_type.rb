module Types
  class ExampleType < LichenGraphql::DynamicType

    # def initialize
    #   super(::Example, options)
    #   options can contain:
    #  {
    #   :uuid_as_id => true/false,
    #   :query_string_search => true/false,
    #   :field_name => 'example',
    #   :mutation_types => [:create, :update, :destroy],
    #   :query_types => [:index, :show],
    #   :singleton => true/false,
    #  }
    #   @permission_class = ExempleTypePermissionAssertion
    # end

    # def collection(context)
    #   self.model.all
    # end

    # def create_query_type
    #   super do |definer, base_query_type|
    #     add more fields here
    #   end
    # end

    # def create_mutation_type
    #   super do |definer, base_query_type|
    #     add more fields here
    #   end
    # end

  ### Methods form module Subtypes::BaseQueryType ###

    # def create_base_query_type
    #   super do |definer|
    #     definer.field 'niveaux', ::LichenGraphql::Utils.find_base_query_type(::Niveaux::NiveauZonage).to_list_type do
    #       resolve ->(obj, args, ctx) {
    #         obj.niveaux_zonages
    #       }
    #     end
    #     definer.field 'methode', ::GraphQL::INT_TYPE
    #   end
    # end

    # Columns that will be available for viewing to GraphQL Api
    # def included_query_columns
    #   super
    # end

  ### Methods form module Subtypes::BaseSearchType ###

    # def create_base_mutation_type
    #   super do |definer|
    #     add more arguments here
    #   end
    # end

    # Columns that will be available for chanigng to GraphQL Api
    # def included_mutation_columns
    #   super
    # end

  ### Methods form module Subtypes::BaseSearchType ###

    # def create_base_search_type
    #   super do |definer|
    #     add more arguments here
    #   end
    # end

    # def create_relation_search_type
    #   super do |definer|
    #     add more arguments here
    #   end
    # end

    # Columns that can be searched in this table
    # def included_search_columns
    #  []
    # end

    # def included_search_relations
    #   {}
    #   keys are model reflections, values are the queries needed to search for them.
    #   Ex: {'auteur', 'unaccent(auteurs.nom) ILIKE ?'}
    # end

    # def search_by_attrs_resolve(obj, args, ctx)
    #   super do |search_results|
    #     modify search results here (scope, order, etc.)
    #   end
    # end

    # def search_by_q_resolve(obj, args, ctx)
    #   define where to search with given query (columns, reltions)
    # end

### Methods form module Subtypes::RelationFields ###

    # Model reflections that can be retrieved when querying this type
    # def included_reflections_for_query
    #   super
    # end


    # Define optional PermissionAssertion class to give extra authorization restrictions to Api
    # @resolve_func: Callback function called by query
    # class ExempleTypePermissionAssertion < ::LichenGraphql::PermissionAssertion
    #     def call(obj, args, ctx)
    #       user = ctx[:current_user]
    #       unless user && user.has_role?(:admin)
    #         @collection = user.exemple_items
    #       end
    #       @resolve_func.call(obj, args, ctx)
    #     end
    #   end
    #
    #   private_constant :ExempleTypePermissionAssertion


  end
end
