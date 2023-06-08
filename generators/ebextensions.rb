# frozen_string_literal: true

copy_file '.ebextensions/00_set_vars.config'
copy_file '.ebextensions/01_upgrade_postgresql.config'
copy_file '.ebextensions/02_set_up_swap.config'
copy_file '.ebextensions/03_yarn.config'
copy_file '.ebextensions/04_assets_compilation.config'
copy_file '.ebextensions/05_ignore_health_check.config'
copy_file '.ebextensions/06_force_ruby_platform.config'
