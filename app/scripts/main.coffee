requirejs.config
    # By default load any module IDs from scripts/vendor
    baseUrl: 'scripts/vendor'

    # paths for listen components and its templates
    paths: 
        listen: '../listen'
        tmpl: '../listen/templates'
    

# start it all up! note that Backbone and Parse are not configured for requirejs and instead define globals, which works fine too.
requirejs ['jquery.min', 'underscore-min', 'listen/list-model', 'listen/list-view', 'backbone-min', 'parse'], ( $, _, Listen, ListView ) ->
    console.log "we're in."

    # Initialize Parse! app name: listen
    Parse.initialize("9l30htqviXhkKi1joswe7qXREsXshiZbDIYddrct", "pYvFENQ2UKkQEkK0cPGSmVRiqxqa3trDqoW7kkDQ")

    # make a new list
    # list = new Listen.List()
    # list.query = new Parse.Query(Listen.ListItem)
    
    # create and render a default list view  
    listView = new ListView
        model: new Listen.ListCollection() # get all ListItems
        title: 'My First List'
    listView.render();
