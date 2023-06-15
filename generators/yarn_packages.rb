# frozen_string_literal: true

run 'yarn add @hotwired/stimulus'
run 'yarn add @hotwired/turbo-rails'
run 'yarn add @rails/ujs'
run 'yarn add esbuild@^0.16.5'
run 'yarn add esbuild-rails@^1.0.4'
run 'yarn add glob'
run 'yarn add sass'
run 'yarn add sweetalert2'

inject_into_file 'package.json', before: "\n dependencies" do
  <<-'CODE'
  "name": "app",
  "private": "true",
  CODE
end
