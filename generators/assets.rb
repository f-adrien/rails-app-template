# frozen_string_literal: true

# IMAGES

copy_file 'app/assets/images/default-avatar.png'

# STYLESHEETS

# Components

copy_file 'app/assets/stylesheets/components/_button.scss'
copy_file 'app/assets/stylesheets/components/_confirm_modal.scss'
copy_file 'app/assets/stylesheets/components/_flashes.scss'
copy_file 'app/assets/stylesheets/components/_index.scss'
copy_file 'app/assets/stylesheets/components/_layout.scss'
copy_file 'app/assets/stylesheets/components/_modal.scss'
copy_file 'app/assets/stylesheets/components/_navbar.scss'
copy_file 'app/assets/stylesheets/components/_sidebar.scss'

# Config

copy_file 'app/assets/stylesheets/config/_colors.scss'
copy_file 'app/assets/stylesheets/config/_fonts.scss'
copy_file 'app/assets/stylesheets/config/_index.scss'
copy_file 'app/assets/stylesheets/config/_utilities.scss'

# Devise

copy_file 'app/assets/stylesheets/devise/_devise.scss'

# Application

copy_file 'app/assets/stylesheets/application.bootstrap.scss', force: true
copy_file 'app/assets/stylesheets/application.scss', force: true
