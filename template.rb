# frozen_string_literal: true

def apply_template!
  add_template_repository_to_source_path

  # create_ebextensions_file
  # create_platform_hooks
  apply 'generators/assets.rb'

  install_gems

  after_bundle do
    rails_command('db:create')

    generate('simple_form:install', '--bootstrap')
    install_devise('user')

    rails_command('db:migrate')

    install_yarn_packages

    create_js_files
    create_controllers

    git :init
    git add: '.'
    git commit: %( -m 'Initial commit' )
  end
end

def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    # If this file was invoked remotely via HTTP, that means the files are not present locally.
    # In that case, use `git clone` to download them to a local temporary dir.
    # And add this template directory to source_paths so that Thor actions like
    # copy_file and template resolve against our source files. 
    require 'tmpdir'

    source_paths.unshift(tempdir = Dir.mktmpdir('rails-app-template-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    git clone: ['--quiet', 'https://github.com/f-adrien/rails-app-template.git', tempdir].map(&:shellescape).join(' ')
    if (branch = __FILE__[%r{rails-app-template/(.+)/template.rb}, 1])
      Dir.chdir(tempdir) { git checkout: branch }
    end
    tempdir
  else
    source_paths.unshift(File.dirname(__FILE__))
    __dir__
  end
end

apply_template!
