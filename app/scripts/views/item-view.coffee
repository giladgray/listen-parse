define ['listen', 'models/list-model', 'vendor/spin'], (Listen) ->   # 'text!tmpl/list-item.jst'], 
	# The DOM element for a list item...
	Listen.ItemView = Parse.View.extend
		#... is a list tag.
		tagName: 'li'
		className: 'editable'
		
		# The DOM events specific to an item.
		events:
			'dblclick': 'edit'
			'click .icon-remove': 'clear'
			'keypress .edit': 'updateOnEnter'
			'blur .edit': 'close'
		
		# The ItemView listens for changes to its model, re-rendering. Since there's
		# a one-to-one correspondence between a ListItem and an ItemView in this
		# app, we set a direct reference on the model for convenience.
		initialize: ->
			# Cache the template function for a single item.
			# template comes from parent view, can be function or string.
			@template = @options.template #if _.isFunction(@options.template) then @options.template else _.template(@options.template)

			_.bindAll this, 'render', 'close', 'remove'
			@model.bind 'change', @render
			@model.bind 'destroy', @remove
		
		# Re-render the contents of the todo item.
		# render: ->
		# 	$(@el).html @template(@model.toJSON())
		# 	@input = @$('.edit')
		# 	@

		afterRender: -> 
			@input = @$('.edit')
		
		serialize: -> @model.toJSON()

		# Switch this view into 'editing' mode, displaying the input field.
		edit: ->
			$(@el).addClass 'editing'
			@input.focus()
		
		# Close the 'editing' mode, saving changes to the todo.
		close: ->
			if @$el.hasClass 'editing'
				@$el.removeClass 'editing'
				# show a spinner while the request is pending (too fast to see...)
				# TODO: move these options somewhere else!
				@$el.spin lines: 9, width: 2, length: 4, radius: 4, right: 26
				@model.save { content: @input.val() },
					success: => @$el.spin false

		# If you hit `enter`, we're through editing the item.
		updateOnEnter: (e) ->
			@close()  if e.keyCode is 13
		
		# Remove the item, destroy the model.
		clear: ->
			# prompt the user if the confirm option is true (weird inverted if)
			unless @options.confirm and not confirm('Are you sure you want to delete this item?')
				@model.destroy()
