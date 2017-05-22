# -*- encoding: utf-8 -*-
# stub: lichen_graphql 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "lichen_graphql"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Natalia Ch\u{e9}telat"]
  s.date = "2017-05-17"
  s.description = "Adapt rails model to GraphQL"
  s.email = ["nataliachetelat@gmail.com"]
  s.files = ["MIT-LICENSE", "README.rdoc", "Rakefile", "app/controllers", "app/controllers/lichen_graphql", "app/controllers/lichen_graphql/queries_controller.rb", "app/models", "app/models/lichen_graphql", "app/models/lichen_graphql/dynamic_type.rb", "app/models/lichen_graphql/mutation_type.rb", "app/models/lichen_graphql/permission_assertion.rb", "app/models/lichen_graphql/query_type.rb", "app/models/lichen_graphql/registry.rb", "app/models/lichen_graphql/schema.rb", "app/models/lichen_graphql/subtypes", "app/models/lichen_graphql/subtypes/base_mutation_type.rb", "app/models/lichen_graphql/subtypes/base_query_type.rb", "app/models/lichen_graphql/subtypes/base_search_type.rb", "app/models/lichen_graphql/subtypes/relation_fields.rb", "app/models/lichen_graphql/type_store.rb", "app/models/lichen_graphql/utility_types.rb", "app/models/lichen_graphql/utils.rb", "config/routes.rb", "lib/generators", "lib/generators/lichen_graphql", "lib/generators/lichen_graphql/USAGE", "lib/generators/lichen_graphql/install_generator.rb", "lib/generators/lichen_graphql/templates", "lib/generators/lichen_graphql/templates/exemple_type.rb", "lib/generators/lichen_graphql/templates/queries_controller.rb", "lib/generators/lichen_graphql/templates/registered_types.rb", "lib/lichen_graphql", "lib/lichen_graphql.rb", "lib/lichen_graphql/engine.rb", "lib/lichen_graphql/version.rb", "lib/tasks", "lib/tasks/lichen_graphql_tasks.rake"]
  s.homepage = "https://github.com/n-chetelat"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = ""

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 0"])
      s.add_runtime_dependency(%q<graphql>, [">= 0"])
    else
      s.add_dependency(%q<rails>, [">= 0"])
      s.add_dependency(%q<graphql>, [">= 0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 0"])
    s.add_dependency(%q<graphql>, [">= 0"])
  end
end
