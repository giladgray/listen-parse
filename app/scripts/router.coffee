# Application.
define ['listen', 'views/index-view', 'views/list-view', 'views/login-view', 'views/navbar-view', 'views/user-view'], (Listen) ->
  # Defining the application router, you can attach sub routers here.
  Router = Parse.Router.extend
  
    routes:
      '': 'index'
      'login': 'login'
      'list/:id': 'list'
      'user': 'user'
      'user/:name': 'user'

    initialize: ->
      # set the app layout and render the navbar. these will appear on every page
      Listen.useLayout 'index'
      Listen.layout.setView('#navbar', new Listen.NavbarView()).render()

    index: ->
      # the index page contains an IndexView with hardcoded title, tagline
      Listen.layout.setView('#contents', new Listen.IndexView
        title: 'Listen!'
        tagline: 'here are all of the lists'
        model: new Listen.ListCollection()
      ).render()

    user: (username) ->
      # display a User page if the username exists
      if username
        query = new Parse.Query(Parse.User)
        query.equalTo 'username', username
        query.first
          success: (user) ->
            Listen.layout.setView('#contents', new Listen.UserView(model: user)).render()
          error: (user, error) ->
            # what happens here? null model?
      else
        Listen.layout.setView('#contents', new Listen.UserView(model: Parse.User.current())).render()


    list: (listId, title) ->
      # lookup the requested list and then make a ListView for it
      @list = new Listen.List
        id: listId
      @list.fetch
        success: =>
          Listen.layout.setView('#contents', new Listen.ListView(model: @list)).render()
        error: =>
          Parse.history.navigate '', true

    login: ->
      Listen.layout.setView('#contents', new Listen.LoginView()).render()

