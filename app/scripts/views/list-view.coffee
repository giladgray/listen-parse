define ['listen', 'models/list-model', 'views/item-view'], (Listen) ->  
	# ListView class displays ordered collection of ListItems
	Listen.ListView = Parse.View.extend
		template: 'list'
		itemTemplate: 'list-item'
		actionsTemplate: 'list-actions'

		className: 'list'

		events:
			'keypress #newItem': 'createOnEnter'
			'click .privacy button': 'changePrivacy'
			'dblclick .editable': 'edit'
			'keypress .edit': 'updateOnEnter'
			'blur .edit': 'close'

		initialize: ->
			# scope instance functions correctly
			_.bindAll this, 'addOne', 'addAll', 'addSome', 'render', 'createOnEnter' #, 'toggleAllComplete', 'logOut'

			# cache selectors
			@input = @$('#newItem')
			@listEl = @$('#list')

			@model.on 'change', @render

			# create a collection that loads ListItems from this list
			@list = Listen.createItemCollection(@model)

			# collection events to update UI
			@list.bind 'add',   @addOne
			@list.bind 'reset', @addAll
			@list.bind 'all',   @render

			@list.fetch()

		serialize: -> @model.toJSON()

		# render: ->
			# render() just needs to update statistics, once we have some.

		beforeRender: ->
			@setView '#actions', new Parse.View
				template: @actionsTemplate
				serialize: => privacy: @model.get('privacy')
			# Iterate over the passed collection and create a view for each item.
			@list.each (model) =>
				# Pass the sample data to the new SomeItem View.
				@insertView '#list', new Listen.ItemView
					model: model
					template: @itemTemplate

		# If you hit return in the main input field, create new ListItem model
		createOnEnter: (e) ->
			return unless e.keyCode is 13
			@list.create 
				content:  @$('#newItem').val()
				order:    @list.nextOrder()
				list:     @model
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

		changePrivacy: (e) ->
			oldPrivacy = @model.get('privacy')
			newPrivacy = e.currentTarget.attributes['title'].value
			@model.save privacy: newPrivacy
			# @$('#actions').html @actionsTemplate(@model.toJSON())

		# Switch this view into 'editing' mode, displaying the input field.
		edit: (e) ->
			console.log 'editing', e.currentTarget
			el = $(e.currentTarget).addClass 'editing'
			el.find('input').focus()
		
		# Close the 'editing' mode, saving changes to the todo.
		close: (e) ->
			el = $(e.currentTarget).parent()
			if el.hasClass 'editing'
				el.removeClass 'editing'
				value = el.find('input').val() 
				console.log "setting #{el.data('field')} to #{value}"
				@model.save el.data('field'), value
				# el.find('.view').text(value)

		# If you hit `enter`, we're through editing the item.
		updateOnEnter: (e) ->
			@close(e)  if e.keyCode is 13

