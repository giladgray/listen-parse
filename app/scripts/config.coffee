# Set the require.js configuration for your application.
require.config
  # baseUrl: '../scripts/vendor'
  # Initialize the application with the main application file.
  deps: ["jquery", "main", "bootstrap/bootstrap-button", "bootstrap/bootstrap-dropdown", "bootstrap/bootstrap-tooltip"]
  paths:
    # JavaScript folders.
    libs: "../scripts/libs"
    plugins: "../scripts/plugins"
    
    # Libraries.
    jquery: "../scripts/libs/jquery"
    lodash: "../scripts/libs/lodash"
    backbone: "../scripts/libs/backbone"
    parse: "../scripts/vendor/parse"
    bootstrap: "../scripts/vendor/bootstrap"

  shim:
    # Backbone library depends on lodash and jQuery.
    backbone:
      deps: ["lodash", "jquery"]
      exports: "Backbone"

    parse:
      deps: ["lodash", "jquery"]
      exports: "Parse"
    
    # Backbone.LayoutManager depends on Backbone.
    "plugins/backbone.layoutmanager": ["parse"]

