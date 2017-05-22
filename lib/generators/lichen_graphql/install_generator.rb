module LichenGraphql
  module Generators

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)


      def copy_graphql_files
        copy_file "registered_types.rb", "app/graphql/registered_types.rb"
        copy_file "exemple_type.rb", "app/graphql/types/exemple_type.rb"
        copy_file "queries_controller.rb", "app/controllers/queries_controller.rb"
        route "resources :queries, only: [:create]"
      end


    end
  end
end
