# frozen_string_literal: true

def apply_template!
  add_template_repository_to_source_path

  Dir["#{__dir__}/helpers/*"].sort.each(&method(:require))

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

  def add_template_repository_to_source_path
    if __FILE__ =~ %r{\Ahttps?://}
      require 'tmpdir'
      source_paths.unshift(tempdir = Dir.mktmpdir('rails-template-'))
      at_exit { FileUtils.remove_entry(tempdir) }
      git clone: [
        '--quiet',
        'https://github.com/f-adrien/rails-app-template.git',
        tempdir
      ].map(&:shellescape).join(' ')

      if (branch = __FILE__[%r{rails-template/(.+)/template.rb}, 1])
        Dir.chdir(tempdir) { git checkout: branch }
      end
    else
      source_paths.unshift(File.dirname(__FILE__))
    end
  end
end

apply_template!
