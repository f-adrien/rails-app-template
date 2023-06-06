# frozen_string_literal: true

Dir["#{__dir__}/helpers/*"].sort.each(&method(:copy_file))

require_relative 'helpers/gems_to_load'

install_gems
generate('simple_form:install', '--bootstrap')

install_yarn_packages

define_routes

devise_model = 'user'

after_bundle do
  install_devise(devise_model)

  create_controllers
  create_js_files

  run 'yarn install'

  rails_command('db:create')
  # rails_command('db:migrate')

  git :init
  git add: '.'
  git commit: %( -m 'Initial commit' )
end
