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
			# template comes from parent view, can be function or string.
			# this allows for reuse of this class in many different lists
			@template = @options.template 
			_.bindAll this, 'render', 'close', 'remove'
			@model.bind 'change sync', @render
			@model.bind 'destroy', @remove

		afterRender: -> 
			@input = @$('.edit')
		
		# contains all model attributes and a value indicating if item
		# is editable in current context
		serialize: -> 
			$.extend @model.toJSON(),
				editable: @isEditable()

		isEditable: ->
			# does the current user have write access to this model?
			@model.getACL().getWriteAccess(Parse.User.current()) or false

		# Switch this view into 'editing' mode, displaying the input field.
		edit: ->
			if @isEditable()
				$(@el).addClass 'editing'
				@input.focus()
		
		# Close the 'editing' mode, saving changes to the todo.
		close: ->
			if @$el.hasClass 'editing'
				@$el.removeClass 'editing'
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
