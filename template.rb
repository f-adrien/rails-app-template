# frozen_string_literal: true

def apply_template!
  add_template_repository_to_source_path

  apply 'generators/ebextensions.rb'
  apply 'generators/platform_hooks.rb'
  # create_platform_hooks
  apply 'generators/gems_to_load.rb'

  apply 'generators/assets.rb'
  apply 'generators/controllers.rb'

  after_bundle do
    rails_command('db:create')

    generate('simple_form:install', '--bootstrap')
    apply 'generators/devise.rb'

    rails_command('db:migrate')

    apply 'generators/yarn_packages.rb'

    create_js_files

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
