requirejs.config
    # By default load any module IDs from scripts/vendor
    baseUrl: 'scripts/vendor'

    # paths for listen components and its templates
    paths: 
        listen: '../listen'
        tmpl: '../listen/templates'

    deps: ['jquery.min', 'underscore-min', 'parse', 'spin', 'bootstrap/bootstrap-button', 'bootstrap/bootstrap-dropdown']
    

# start it all up! note that Backbone and Parse are not configured for requirejs and instead define globals, which works fine too.
requirejs ['listen/router', 'listen/list-model', 'listen/list-view'], 
    ( ListenRouter, Listen, ListView ) ->
        $ = jQuery
        
        console.log "we're in."

        # Initialize Parse! app name: listen
        Parse.initialize("9l30htqviXhkKi1joswe7qXREsXshiZbDIYddrct", "pYvFENQ2UKkQEkK0cPGSmVRiqxqa3trDqoW7kkDQ")

        # make a new list
        # list = new Listen.List()
        # list.query = new Parse.Query(Listen.ListItem)
        window.Listen = 
            router: new ListenRouter()
        Parse.history.start(pushState: true)

        # AJAX events to show/hide spinner in upper left corner
        $.bind 'ajaxStart', -> $('#title').spin left: 0
        $.bind 'ajaxStop', -> $('#title').spin false
        
        # create and render a default list view  
        # listView = new ListView
        #     model: new Listen.ListCollection() # get all ListItems
        #     title: 'My First List'
        #     tagline: 'a playground for testing'
        # listView.render();
