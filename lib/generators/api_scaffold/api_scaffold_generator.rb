require "rails/generators"
require "rails/generators/rails/scaffold/scaffold_generator"

module ApiScaffold
  class ApiScaffoldGenerator < Rails::Generators::ScaffoldGenerator
    remove_hook_for :scaffold_controller
    remove_hook_for :resource_route

    source_root File.expand_path("templates", __dir__)

    def create_blueprint_files
      blueprint_path = File.join("app/blueprints", "#{file_name}_blueprint.rb")
      template "blueprint.rb.erb", blueprint_path
    end

    def create_controller_files
      template "controller.rb.erb",
               File.join("app/controllers/api/v1", "#{plural_name}_controller.rb")
    end

    def create_service_files
      template "create_service.rb.erb", File.join("app/services", plural_name, "create_service.rb")
      template "update_service.rb.erb", File.join("app/services", plural_name, "update_service.rb")
      template "destroy_service.rb.erb", File.join("app/services", plural_name, "destroy_service.rb")
    end

    def add_resource_route
      insert_api_v1_route
    end

    private

    def insert_api_v1_route
      routes_file = "config/routes.rb"
      content = File.read(routes_file)
      main_api_v1_anchor = /^  namespace :api do\s*\n    namespace :v1 do\s*\n/

      if content.match?(main_api_v1_anchor)
        inject_into_file(
          routes_file,
          "      resources :#{plural_name}\n",
          after: main_api_v1_anchor
        )
      else
        route <<~RUBY
          namespace :api do
            namespace :v1 do
              resources :#{plural_name}
            end
          end
        RUBY
      end
    end

    def belongs_to_attributes
      attributes.select { |attr| attr.type == :references }
    end

    def permitted_attributes
      attributes.map do |attribute|
        attribute.type == :references ? "#{attribute.name}_id" : attribute.name
      end.reject { |name| name == "deleted_at" }
    end

    def blueprint_fields
      attributes.reject { |attr| attr.type == :references || hidden_blueprint_fields.include?(attr.name) }
    end

    def hidden_blueprint_fields
      %w[created_by updated_by deleted_at]
    end

    def resource_human_name
      class_name.underscore.humanize
    end

    def resource_collection_module_name
      plural_name.camelize
    end

    def resource_controller_class_name
      plural_name.camelize
    end

    def self_referential_attribute?(attribute)
      attribute.type == :references && [
        singular_table_name,
        "#{singular_table_name}_pai"
      ].include?(attribute.name)
    end
  end
end
