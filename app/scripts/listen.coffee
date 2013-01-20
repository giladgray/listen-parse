#       Libraries                       Plugins
define ['jquery', 'lodash', 'parse', 'plugins/backbone.layoutmanager'], ($, _, Parse) ->
  # Provide a global location to place configuration settings and module creation.

  # The root path to run the application.
  app = 
    root: '/'
    spin: (classes='') ->
      "<i class='icon-spinner icon-spin #{classes}'></i>"
  
  # Localize or create a new JavaScript Template object.
  JST = window.JST = window.JST or {}
  
  # Initialize Parse functionality using the keys for my listen app
  Parse.initialize("9l30htqviXhkKi1joswe7qXREsXshiZbDIYddrct", "pYvFENQ2UKkQEkK0cPGSmVRiqxqa3trDqoW7kkDQ")

  # Configure LayoutManager with Parse Boilerplate defaults.
  Parse.LayoutManager.configure
    manage: true

    paths:
      layout: 'templates/layouts/'
      template: 'templates/'

    fetch: (path) ->
      path = path + '.html'
      unless JST[path]
        $.ajax(
          url: app.root + path
          async: false
        ).then (contents) ->
          JST[path] = _.template(contents)
      JST[path]

  # Mix Parse.Events, modules, and layout management into the app object.
  _.extend app, Parse.Events,
    # Create a custom object with a nested Views object.
    module: (additionalProps) ->
      _.extend
        Views: {}
      , additionalProps

    # Helper for using layouts.
    useLayout: (name) ->
      # If already using this Layout, then don't re-inject into the DOM.
      return @layout  if @layout and @layout.options.template is name
      
      # If a layout already exists, remove it from the DOM.
      @layout.remove()  if @layout
      
      # Create a new Layout.
      layout = new Parse.Layout(
        template: name
        className: 'layout ' + name
        id: 'layout'
      )
      
      # Insert into the DOM.
      $('#main').empty().append layout.el
      
      # Render the layout.
      layout.render()
      
      # Cache the refererence.
      @layout = layout
      
      # Return the reference, for chainability.
      layout
