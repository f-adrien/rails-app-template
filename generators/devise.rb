# frozen_string_literal: true

def install_devise!(model_name)
  generate 'devise:install'
  generate 'devise', model_name
  override_migration_file(model_name)
  generate('devise:controllers', "#{model_name}s")
  copy_file 'app/controllers/users/sessions_controller.rb', force: true
  copy_file 'app/controllers/users/devise_controller.rb'
  initializer_path = 'config/initializers/devise.rb'
  copy_file initializer_path, force: true
  from_email = ask("Default 'From' address for Devise emails ?", default: 'email@example.com')
  gsub_file(initializer_path, 'please-change-me-at-config-initializers-devise@example.com', from_email)
  generate('devise:views', model_name)
  copy_file 'app/views/devise/sessions/new.html.erb', force: true
end

def override_migration_file(model_name)
  migration_file = Dir.glob("db/migrate/*_devise_create_#{model_name.downcase}s.rb").first
  inject_into_file migration_file, after: "create_table :users do |t|\n" do
    <<-'RUBY'
      t.string :first_name
      t.string :last_name

    RUBY
  end

  gsub_file migration_file, '# t.integer  :failed_attempts', 't.integer  :failed_attempts'
  gsub_file migration_file, '# t.string   :unlock_token', 't.string   :unlock_token'
  gsub_file migration_file, '# t.datetime :locked_at', 't.datetime :locked_at'
end

install_devise!('user')
