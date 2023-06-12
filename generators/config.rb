# frozen_string_literal: true

# Application config

copy_file 'config/application.rb', force: true
copy_file 'config/storage.yml', force: true
copy_file 'config/shoryuken.yml'

# Environments

copy_file 'config/environments/development.rb', force: true
copy_file 'config/environments/test.rb', force: true
copy_file 'config/environments/production.rb', force: true

# Initializers

copy_file 'config/initializers/assets.rb'
copy_file 'config/initializers/aws.rb'