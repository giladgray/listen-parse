define ['text!tmpl/list.jst', 'text!tmpl/index-item.jst', 'text!tmpl/list-actions.jst', 'listen/item-view'], 
	(indexTemplate, indexItemTemplate, listActionsTemplate, ItemView) ->
		IndexView = Parse.View.extend
			template: _.template(indexTemplate)
			itemTemplate: _.template(indexItemTemplate)

			className: 'list'

			events:
				'keypress #newItem': 'createOnEnter'
				'click .input-submit': 'createOnEnter'
				'click a': 'navigate'

			initialize: ->
				# render the template initially, then we don't need to touch it again
				@$el.html @template(@options)
				@$('#list-actions').html _.template(listActionsTemplate)()

				# scope instance functions correctly
				_.bindAll this, 'addOne', 'addAll', 'addSome', 'render', 'createOnEnter' #, 'toggleAllComplete', 'logOut'

				# cache selectors
				@input = @$('#newItem')
				@listEl = @$('#list')

				@list = @model

				# collection events to update UI
				@list.bind 'add',   @addOne
				@list.bind 'reset', @addAll
				@list.bind('all',   @render)

				@list.fetch()

			render: ->
				# render() just needs to update statistics, once we have some.

			# If you hit return in the main input field, create new ListItem model
			createOnEnter: (e) ->
				# gtfo if key pressed and it isn't ENTER   -or-   text field is blank
				return if (e.keyCode and e.keyCode isnt 13) or (/^$/.test @input.val())
				@list.create
					title: @input.val()
					# user:   Parse.User.current()
					# ACL:    new Parse.ACL(Parse.User.current())
				# creating an item triggers the 'add' event bound above
				@input.val('')

			# Add a single list item to the list by creating a view for it, and
			# appending its element to the `<ul>`.
			addOne: (item) ->
				item.save
					success: =>
						view = new ItemView 
							model: item
							template: @itemTemplate
							confirm: true
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
