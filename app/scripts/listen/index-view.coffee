define ['text!tmpl/list.jst', 'text!tmpl/index-item.jst', 'listen/item-view', 'parse'], 
	(indexTemplate, indexItemTemplate, ItemView) ->
		IndexView = Parse.View.extend
			template: _.template(indexTemplate)
			itemTemplate: _.template(indexItemTemplate)

			className: 'list'

			events:
				'keypress #newItem': 'createOnEnter',
				'click a': 'navigate'

			initialize: ->
				# render the template initially, then we don't need to touch it again
				@$el.html @template(@options)

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

				# AJAX events to show/hide spinner in upper left corner
				$.bind 'ajaxStart', -> $('#title').spin left: 0
				$.bind 'ajaxStop', -> $('#title').spin false

			render: ->
				# render() just needs to update statistics, once we have some.

			# If you hit return in the main input field, create new ListItem model
			createOnEnter: (e) ->
				return unless e.keyCode is 13
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
			    e.preventDefault()
			    href = e.currentTarget.attributes['href'].value
			    console.log "navigating to #{href}"
			    window.Listen.router.navigate href, trigger: true
