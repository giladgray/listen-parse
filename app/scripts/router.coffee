# Application.
define ['listen', 'views/index-view', 'views/list-view'], (Listen) ->
  # Defining the application router, you can attach sub routers here.
  Router = Parse.Router.extend
  
    routes:
      '': 'index'
      'user/:id': 'user'
      'list/:id': 'list'

    initialize: ->
      Listen.useLayout 'index'

    index: ->
      console.log 'index!'
      Listen.layout.setView '#contents', new Listen.IndexView
        title: 'Listen!'
        tagline: 'here are all of the lists'
        model: new Listen.ListCollection()
      Listen.layout.render()

    user: (id) ->
      console.log 'user!', id

    list: (listId, title) ->
      console.log 'list!', listId, title
      @list = new Listen.List
        id: listId
      @list.fetch
        success: =>
          Listen.layout.setView('#contents', new Listen.ListView(model: @list)).render()
