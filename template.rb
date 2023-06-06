# frozen_string_literal: true

def apply_template!
  add_template_repository_to_source_path

  Dir["#{helpers_source_path}/helpers/*"].sort.each(&method(:require))

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
end

def helpers_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    # Add this template directory to source_paths so that Thor actions like
    # copy_file and template resolve against our source files. If this file was
    # invoked remotely via HTTP, that means the files are not present locally.
    # In that case, use `git clone` to download them to a local temporary dir.
    require 'tmpdir'
    # This
    source_paths.unshift(tempdir = Dir.mktmpdir('rails-app-template-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: ['--quiet', 'https://github.com/f-adrien/rails-app-template.git', tempdir].map(&:shellescape).join(' ')
    if (branch = __FILE__[%r{rails-app-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
    tempdir
  else
    __dir__
  end
end

apply_template!
