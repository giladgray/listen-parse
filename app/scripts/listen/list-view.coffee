define ['listen/list-model', 'listen/item-view', 'text!tmpl/list.jst', 'text!tmpl/list-item.jst', 'text!tmpl/new-item.jst', 'text!tmpl/list-actions.jst',], 
	(Listen, ItemView, listTemplate, listItemTemplate, newItemTemplate, listActionsTemplate) ->  
		# ListView class displays ordered collection of ListItems
		ListView = Parse.View.extend
			template: _.template(listTemplate)
			itemTemplate: _.template(listItemTemplate)
			actionsTemplate: _.template(listActionsTemplate)

			className: 'list'

			events:
				'keypress #newItem': 'createOnEnter'
				'click a': 'navigate'
				'click .privacy button': 'changePrivacy'
				'dblclick .editable': 'edit'
				'keypress .edit': 'updateOnEnter'
				'blur .edit': 'close'

			initialize: ->
				@template = _.template(@options.template or listTemplate)
				@itemTemplate = _.template(@options.itemTemplate or listItemTemplate)

				# render the template initially, then we don't need to touch it again
				@$el.html @template(@model.toJSON())
				@$('#actions').html @actionsTemplate(@model.toJSON())

				# scope instance functions correctly
				_.bindAll this, 'addOne', 'addAll', 'addSome', 'render', 'createOnEnter' #, 'toggleAllComplete', 'logOut'

				# cache selectors
				@input = @$('#newItem')
				@listEl = @$('#list')

				# create a collection that loads ListItems from this list
				@list = Listen.createItemCollection(@model)

				# collection events to update UI
				@list.bind 'add',   @addOne
				@list.bind 'reset', @addAll
				@list.bind 'all',   @render

				@list.fetch()

			render: ->
				# render() just needs to update statistics, once we have some.

			# If you hit return in the main input field, create new ListItem model
			createOnEnter: (e) ->
				return unless e.keyCode is 13
				@list.create 
					content: 	@input.val()
					order:    @list.nextOrder()
					list:     @model
					# user:   Parse.User.current()
					# ACL:    new Parse.ACL(Parse.User.current())
				# creating an item triggers the 'add' event bound above
				@input.val('')

			# Add a single list item to the list by creating a view for it, and
			# appending its element to the `<ul>`.
			addOne: (item) ->
				view = new ItemView 
					model: item
					template: @itemTemplate
				@listEl.append(view.render().el)

			# Add all items in the List collection at once.
			addAll: (collection, filter) ->
				@listEl.html("")
				@list.each @addOne

			# Only adds some items, based on a filtering function that is passed in
			addSome: (filter) ->
				@listEl.html("");
				@list.chain().filter(filter).each (item) -> @addOne(item)

			changePrivacy: (e) ->
				oldPrivacy = @model.get('privacy')
				newPrivacy = e.currentTarget.attributes['title'].value
				@model.save privacy: newPrivacy
				@$('#actions').html @actionsTemplate(@model.toJSON())

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
					el.find('.view').text(value)

			# If you hit `enter`, we're through editing the item.
			updateOnEnter: (e) ->
				@close(e)  if e.keyCode is 13
				
			navigate: (e) ->
				unless e.currentTarget.classList.contains('dropdown-toggle')
					e.preventDefault()
					href = e.currentTarget.attributes['href'].value
					console.log "navigating to #{href}"
					window.Listen.router.navigate href, trigger: true

