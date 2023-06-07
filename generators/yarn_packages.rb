# frozen_string_literal: true

def install_yarn_packages
  run 'yarn add @hotwired/stimulus'
  run 'yarn add @hotwired/turbo-rails'
  run 'yarn add @rails/ujs'
  run 'yarn add esbuild-rails'
  run 'yarn add sass'
  run 'yarn add sweetalert2'
end
