define ['listen'], (Listen) ->
	Listen.NavbarView = Parse.View.extend
		template: 'navbar'

		className: 'navbar-inner'

		events:
			'click .icon-signout': 'logout'

		initialize: ->
			Listen.on 'login', @render, @

		serialize: -> 
			if Parse.User.current()
				username: Parse.User.current().get('username')

		logout: (e) ->
			Parse.User.logOut()
			@render()