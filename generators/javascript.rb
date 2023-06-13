# frozen_string_literal: true

# ES Build Config
copy_file 'esbuild.config.js'
gsub_file('package.json',
          'esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds --public-path=assets',
          'node esbuild.config.js')
gsub_file('package.json',
          'sass ./app/assets/stylesheets/application.bootstrap.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules',
          'sass ./app/assets/stylesheets/application.bootstrap.scss ./app/assets/builds/application.css --no-source-map --load-path=node_modules')

# JS files

copy_file 'app/javascript/packs/application.js'

# Stimulus

copy_file 'app/javascript/controllers/index.js', force: true
copy_file 'app/javascript/controllers/flashes_controller.js'
copy_file 'app/javascript/controllers/modal_controller.js'
copy_file 'app/javascript/controllers/sweet_alert_controller.js'
