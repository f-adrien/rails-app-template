# frozen_string_literal: true

run 'yarn add @hotwired/stimulus'
run 'yarn add @hotwired/turbo-rails'
run 'yarn add @rails/ujs'
run 'yarn add esbuild-rails'
run 'yarn add sass'
run 'yarn add sweetalert2'

gsub_file('package.json',
          'esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds --public-path=assets',
          'node esbuild.config.js')
