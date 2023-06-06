# frozen_string_literal: true

def install_devise(model_name)
  generate 'devise:install'
  custom_config_devise
  generate 'devise', model_name
  override_migration_file(model_name)
  generate('devise:controllers', "#{model_name}s")
  override_default_controllers(model_name)
  create_custom_controllers(model_name)
  generate('devise:views', model_name)
end

def custom_config_devise
  path = 'config/initializers/devise.rb'

  inject_into_file path, after: "# frozen_string_literal: true\n" do
    <<~RUBY

      class TurboFailureApp < Devise::FailureApp
        def respond
          if request_format == :turbo_stream
            redirect
          else
            super
          end
        end

        def skip_format?
          %w[html turbo_stream */*].include? request_format.to_s
        end
      end
    RUBY
  end

  from_email = ask("Default 'From' address for Devise emails ?", default: 'aspen43@hotmail.fr')
  gsub_file(path, 'please-change-me-at-config-initializers-devise@example.com', from_email)
end

def override_migration_file(model_name)
  migration_file = Dir.glob("db/migrate/*_devise_create_#{model_name.downcase}s.rb").first
  inject_into_file migration_file, after: "create_table :users do |t|\n" do
    <<-'RUBY'
      t.string :first_name
      t.string :last_name

    RUBY
  end
end

def override_default_controllers(model_name)
  file_path = "app/controllers/#{model_name.downcase}s/sessions_controller.rb"
  # Step 1: Read the file into a string
  file_content = File.read(file_path)

  # Step 2: Find and replace the multiline section using regular expressions
  replacement = <<-REPLACEMENT

  def create
    super
    session[:account_id] = current_user.accounts.first.id
  end
  REPLACEMENT

  # Use the desired regular expression pattern to find the section
  pattern = /(\s*# def create\s*\n\s*#\s*super\s*\n\s*# end)/m
  modified_content = file_content.gsub(pattern, replacement)

  # Step 3: Write the modified content back to the file
  File.open(file_path, 'w') { |file| file.write(modified_content) }
end

def create_custom_controllers(model_name)
  file "app/controllers/#{model_name.downcase}s/devise_controller.rb", <<~RUBY
    # frozen_string_literal: true

    # Purpose: To create a controller for the prospects
    class Users::DeviseController < ActionController::Base
      protect_from_forgery
      # Purpose of this method is to override the default behavior of Devise
      class Responder < ActionController::Responder
        def to_turbo_stream
          controller.render(options.merge(formats: :html))
        rescue ActionView::MissingTemplate => e
          if get?
            raise e
          elsif has_errors? && default_action
            render rendering_options.merge(formats: :html, status: :unprocessable_entity)
          else
            redirect_to Rails.application.routes.url_helpers.home_institutions_path
          end
        end
      end

      self.responder = Responder
      respond_to :html, :turbo_stream
    end
  RUBY
end
