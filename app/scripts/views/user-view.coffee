define ['listen', 'views/item-view', 'models/list-model'], (Listen) ->
	Listen.UserView = Parse.View.extend
		template: 'user'

		initialize: ->
			# query for all lists this user has created
			# only lists visible to the current user will be returned
			@lists = new Listen.ListCollection()
			@lists.query = new Parse.Query(Listen.List)
			@lists.query.equalTo('user', @model).include('user')
			# standard re-render event
			@lists.bind 'all', @render, @
			# aaaand fire that query
			@lists.fetch()

		serialize: -> 
			username: @model.get('username')
			joinedDate: ''
			listCount: @lists.size() or 0

		beforeRender: ->
			# as usual, insert an ItemView for every list
			@lists.each (model) =>
				@insertView '#list', new Listen.ItemView
					model: model
					template: 'index-item'
