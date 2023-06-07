# frozen_string_literal: true

def create_ebextensions_file
  set_vars
  upgrade_postgresql
  set_up_swap
  install_node_and_yarn
  precompile_assets
  increase_eb_timeout
  force_ruby_platform
end

def set_vars
  file '.ebextensions/00_set_vars.config', <<~CODE
    commands:
      01_setvars:
        command: /opt/elasticbeanstalk/bin/get-config environment | jq -r 'to_entries | .[] | "export \(.key)=\"\(.value)\""' > /etc/profile.d/sh.local
  CODE
end

def upgrade_postgresql
  file '.ebextensions/01_upgrade_postgresql.config', <<~CODE
    commands:
      00_enable_postgresql_13:
        command: sudo amazon-linux-extras enable postgresql13
      01_clean:
        command: sudo yum clean metadata
      02_install_postgresql_13:
        command: sudo yum -y install postgresql
  CODE
end

def set_up_swap
  file '.ebextensions/02_set_up_swap.config', <<~CODE
    commands:
      00_create_swap:
        test: test ! -e /var/swapfile
        command: |
          /bin/dd if=/dev/zero of=/var/swapfile bs=1M count=2048
          /bin/chmod 600 /var/swapfile
          /sbin/mkswap /var/swapfile
          /sbin/swapon /var/swapfile
  CODE
end

def install_node_and_yarn
  file '.ebextensions/03_install_node_and_yarn.config', <<~CODE
    commands:
      01_install_node:
        test: '[ ! -f /usr/bin/node ] && echo "node not installed"'
        cwd: /tmp
        command: wget https://rpm.nodesource.com/pub_14.x/el/7/x86_64/nodejs-14.18.1-1nodesource.x86_64.rpm && yum install -y nodejs-14.18.1-1nodesource.x86_64.rpm
      03_install_yarn_repo:
        test: '[ ! -f /etc/yum.repos.d/yarn.repo ] && echo "yarn repo not installed"'
        cwd: /tmp
        command: curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
      04_install_yarn:
        test: '[ ! -f /usr/bin/yarn ] && echo "yarn not installed"'
        command: rpm -Uvh --nodeps $(repoquery --location yarn)
  CODE
end

def precompile_assets
  file '.ebextensions/04_precompile_assets.config', <<~CODE
    container_commands:
      01_precompile_assets:
        command: bundle exec rake assets:precompile
  CODE
end

def increase_eb_timeout
  file '.ebextensions/05_increase_eb_timeout.config', <<~CODE
    option_settings:
      - namespace: aws:elasticbeanstalk:command
        option_name: Timeout
        value: 1000
  CODE
end

def force_ruby_platform
  file '.ebextensions/06_force_ruby_platform.config', <<~CODE
    container_commands:
      00_bundle_force_ruby_platform:
        command: bundle config set force_ruby_platform true
  CODE
end
