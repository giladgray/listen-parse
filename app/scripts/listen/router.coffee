define ['jquery.min', 'underscore-min', 'listen/index-view', 'listen/list-view', 'listen/list-model', 'text!tmpl/index-item.jst', 'parse'], 
	($, _, IndexView, ListView, Listen, indexItemTmpl) ->
		Callbacks =
			createList: (text, list) ->
				title: text

			createListItem: (text, list) ->
				content: text
				order:   list.nextOrder()


		ListenRouter = Parse.Router.extend
			$el: jQuery('#listen')

			routes:
				'': 'index'
				'user/:id': 'user'
				'list/:id': 'list'

			index: ->
				console.log 'index!'
				@view = new IndexView
					title: 'Listen!'
					tagline: 'here are all of the lists'
					model: new Listen.ListCollection()
				@$el.html @view.$el

			user: (id) ->
				console.log 'user!', id

			list: (listId, title) ->
				console.log 'list!', listId, title
				
				@view.remove() if @view
				
				@list = new Listen.List
					id: listId
				@list.fetch
					success: =>
						@view = new ListView
							model: @list
						@$el.html @view.$el

