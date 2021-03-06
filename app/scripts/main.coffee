#     Application, Main Router
require ['Listen', 'router'], (Listen, Router) ->
  # Define your master router on the application namespace and trigger all
  # navigation from this instance.
  Listen.router = new Router()

  # Trigger the initial route and enable HTML5 History API support, set the
  # root folder to '/' by default.  Change in Listen.js.
  Parse.history.start
    # pushState: true
    root: Listen.root

  # Listen.fetch()
  
  # All navigation that is relative should be passed through the navigate
  # method, to be processed by the router. If the link has a `data-bypass`
  # attribute, bypass the delegation completely.
  $(document).on "click", "a:not([data-bypass])", (evt) ->
    # Get the absolute anchor href.
    href = $(this).attr("href")
    
    # If the href exists and is a hash route, run it through Backbone.
    if href and href.indexOf("#") is 0
      # Stop the default event to ensure the link will not cause a page refresh.
      evt.preventDefault()
      # `Backbone.history.navigate` is sufficient for all Routers and will
      # trigger the correct events. The Router's internal `navigate` method
      # calls this anyways.  The fragment is sliced from the root.
      Parse.history.navigate href, true


