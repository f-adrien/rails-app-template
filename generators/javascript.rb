# frozen_string_literal: true

def create_js_files
  create_esbuild_config
  override_app_js
  override_stimulus_index
end

def create_esbuild_config
  file 'esbuild.config.js', <<~CODE
    const glob = require('glob').sync
    const path = require('path')
    const rails = require('esbuild-rails')

    require("esbuild").build({
      entryPoints: glob("./app/javascript/**/*.js"),
      bundle: true,
      sourcemap: false,
      outdir: path.join(process.cwd(), "app/assets/builds"),
      watch: process.argv.includes("--watch"),
      plugins: [rails()],
    }).catch(() => process.exit(1))
  CODE
end

def override_app_js
  insert_into_file 'app/javascript/application.js',
                   before: "// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails\n" do
    <<~'CODE'
      require('@rails/ujs').start();

    CODE
  end
  insert_into_file 'app/javascript/application.js', after: %(import * as bootstrap from "bootstrap"\n) do
    <<~'CODE'

      window.bootstrap = require("bootstrap")
    CODE
  end
  gsub_file('app/javascript/application.js', 'import "controllers"', 'import "./controllers"')
end

def override_stimulus_index
  gsub_file('app/javascript/controllers/index.js',
            %(import HelloController from "./hello_controller"),
            %(import controllers from "./**/*_controller.js"))
  gsub_file('app/javascript/controllers/index.js',
            %(application.register("hello", HelloController)),
            'controllers.forEach((controller) => { application.register(controller.name, controller.module.default) }')
end
