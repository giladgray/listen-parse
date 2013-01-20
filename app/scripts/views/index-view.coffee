define ['listen', 'views/item-view'], (Listen) ->
	Listen.IndexView = Parse.View.extend
		template: 'list'

		className: 'list'

		events:
			'keypress #newItem': 'createOnEnter'
			'click .input-submit': 'createOnEnter'

		initialize: ->
			@list = @model

			# collection event to update UI
			@list.bind 'all', @render, @

			@list.fetch()

		serialize: -> 
			title: @options.title
			tagline: @options.tagline
			editable: Parse.User.current()?

		# Insert all subViews prior to rendering the View.
		beforeRender: ->
			# Iterate over the passed collection and create a view for each item.
			@list.each (model) =>
				# append a new ItemView for each item
				@insertView '#list', new Listen.ItemView
					model: model
					template: 'index-item'
					confirm: true	# ask user before deletion

		afterRender: -> 
			@input = @$('#newItem')

		# If you hit return in the main input field, create new ListItem model
		createOnEnter: (e) ->
			# gtfo if key pressed and it isn't ENTER   -or-   text field is blank
			return if (e.keyCode and e.keyCode isnt 13) or (/^$/.test @input.val())
			@list.create 
				title:  @$('#newItem').val()
				user:   Parse.User.current()
				ACL:    new Parse.ACL(Parse.User.current())
			# creating an item triggers the 'add' event bound above
			@input.val('')
