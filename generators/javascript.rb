# frozen_string_literal: true

# ES Build Config
copy_file 'esbuild.config.js'
# gsub_file(initializer_path, 'please-change-me-at-config-initializers-devise@example.com', from_email)

# JS files

copy_file 'app/javascript/packs/application.js'

# Stimulus

copy_file 'app/javascript/controllers/index.js', force: true
copy_file 'app/javascript/controllers/flashes_controller.js'
copy_file 'app/javascript/controllers/modal_controller.js'
copy_file 'app/javascript/controllers/sweet_alert_controller.js'
