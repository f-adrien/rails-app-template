// Entry point for the build script in your package.json
require('@rails/ujs').start();

import "@hotwired/turbo-rails"
import "../controllers"
import * as bootstrap from "bootstrap"

window.bootstrap = require("bootstrap")
