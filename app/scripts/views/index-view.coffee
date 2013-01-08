define ['listen', 'views/item-view'], (Listen) ->
	Listen.IndexView = Parse.View.extend
		template: 'list'
		itemTemplate: 'index-item'

		className: 'list'

		events:
			'keypress #newItem': 'createOnEnter'
			'click .input-submit': 'createOnEnter'

		initialize: ->
			# scope instance functions correctly
			_.bindAll this, 'addOne', 'addAll', 'addSome', 'render', 'createOnEnter' #, 'toggleAllComplete', 'logOut'

			@list = @model

			# collection events to update UI
			@list.bind 'add',   @addOne
			@list.bind 'reset', @addAll
			@list.bind 'all',   @render

			@list.fetch()

		serialize: -> 
			title: @options.title
			tagline: @options.tagline

		# Insert all subViews prior to rendering the View.
		beforeRender: ->
			# Iterate over the passed collection and create a view for each item.
			@list.each (model) =>
				# Pass the sample data to the new SomeItem View.
				@insertView '#list', new Listen.ItemView
					model: model
					template: @itemTemplate
					confirm: true

		afterRender: -> 
			@input = @$('.edit')

		# If you hit return in the main input field, create new ListItem model
		createOnEnter: (e) ->
			# gtfo if key pressed and it isn't ENTER   -or-   text field is blank
			return if (e.keyCode and e.keyCode isnt 13) or (/^$/.test @input.val())
			@list.create
				title:  @$('#newItem').val()
				# user:   Parse.User.current()
				# ACL:    new Parse.ACL(Parse.User.current())
			# creating an item triggers the 'add' event bound above
			@input.val('')

		# Add a single list item to the list by creating a view for it, and
		# appending its element to the `<ul>`.
		addOne: (item) -> item.save()

		# Add all items in the List collection at once.
		addAll: (collection, filter) ->
			@list.each @addOne

		# Only adds some items, based on a filtering function that is passed in
		addSome: (filter) ->
			@list.chain().filter(filter).each (item) -> @addOne(item)
