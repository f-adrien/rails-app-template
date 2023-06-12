# frozen_string_literal: true

# Layouts

copy_file 'app/views/layouts/application.html.erb', force: true
copy_file 'app/views/layouts/application.turbo_stream.erb'

# Navbar and Sidebar

copy_file 'app/views/layouts/partials/_navbar.html.erb'
copy_file 'app/views/layouts/partials/_sidebar.html.erb'

# Application methods

copy_file 'app/views/application/close_modal.turbo_stream.erb'

# Shared

copy_file 'app/views/shared/_flashes.html.erb'
