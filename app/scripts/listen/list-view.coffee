define ['listen/list-model', 'listen/item-view', 'text!tmpl/list.jst', 'text!tmpl/list-item.jst', 'text!tmpl/new-item.jst', 'text!tmpl/list-actions.jst',], 
	(Listen, ItemView, listTemplate, listItemTemplate, newItemTemplate, listActionsTemplate) ->  
		# ListView class displays ordered collection of ListItems
		ListView = Parse.View.extend
			template: _.template(listTemplate)
			itemTemplate: _.template(listItemTemplate)

			className: 'list'

			events:
				'keypress #newItem': 'createOnEnter',
				'click a': 'navigate'

			initialize: ->
				@template = _.template(@options.template or listTemplate)
				@itemTemplate = _.template(@options.itemTemplate or listItemTemplate)

				# render the template initially, then we don't need to touch it again
				@$el.html @template(@model.toJSON())
				@$('#list-actions').html _.template(listActionsTemplate)()

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

			navigate: (e) ->
				unless e.currentTarget.classList.contains('dropdown-toggle')
					e.preventDefault()
					href = e.currentTarget.attributes['href'].value
					console.log "navigating to #{href}"
					window.Listen.router.navigate href, trigger: true

