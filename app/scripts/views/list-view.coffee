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
			# cache selectors
			@input = @$('#newItem')
			@listEl = @$('#list')

			@model.on 'change', @render, @

			# create a collection that loads ListItems from this list
			@list = Listen.createItemCollection(@model)

			# collection event to update UI
			@list.bind 'all', @render, @

			@list.fetch()


		serialize: -> 
			$.extend @model.toJSON(),
				editable: @isEditable()

		isEditable: ->
			@model.getACL().getWriteAccess(Parse.User.current())

		beforeRender: ->
			@setView '#actions', new Parse.View
				template: @actionsTemplate
				serialize: => 
					privacy: @model.get('privacy')
					editable: @isEditable()
			# Iterate over the passed collection and create a view for each item.
			@list.each (model) =>
				# Pass the sample data to the new SomeItem View.
				@insertView '#list', new Listen.ItemView
					model: model
					template: @itemTemplate


		# If you hit return in the main input field, create new ListItem model
		createOnEnter: (e) ->
			return unless e.keyCode is 13
			acl = new Parse.ACL(Parse.User.current())
			acl.setPublicReadAccess(true)
			acl.setPublicWriteAccess(false)
			@list.create
				content: @$('#newItem').val()
				order:   @list.nextOrder()
				list:    @model
				user:    Parse.User.current()
				ACL:     acl
			# creating an item triggers the 'add' event bound above
			@input.val('')

		changePrivacy: (e) ->
			oldPrivacy = @model.get('privacy')
			newPrivacy = e.currentTarget.attributes['title'].value
			@model.save privacy: newPrivacy
			# @$('#actions').html @actionsTemplate(@model.toJSON())

		# Switch this view into 'editing' mode, displaying the input field.
		edit: (e) ->
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

		# If you hit `enter`, we're through editing the item.
		updateOnEnter: (e) ->
			@close(e)  if e.keyCode is 13

