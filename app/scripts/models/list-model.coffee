define ['listen'], (Listen) ->  

	PrivacyTypes = 
		PRIVATE: 'private'
		PUBLIC : 'public'
		SHARED : 'shared'
	
	# model for a list itself
	Listen.List = Parse.Object.extend
		className: 'List'

		defaults: 
			user: ''
			title: ''
			tagline: ''
			privacy: PrivacyTypes.PRIVATE
			collaborative: false

		initialize: ->

		items: ->
			return @get('items') if @get('items')

			# query = (new Parse.Query(ListItem)).equalTo('list', @)
			# items.fetch()

			@set 'items', new Listen.ListItemCollection(list: @)
			# items

		createItem: (options) ->
			_.extend options, list: @
			@items().create options


	# model for an item in a list
	Listen.ListItem = Parse.Object.extend
		className: 'ListItem'

		defaults:
			content: ''
			order: 0

		comparator: (item) -> item.get('createdAt')


	# collection of items in a list (contained within List?)
	Listen.ListItemCollection = Parse.Collection.extend
		model: Listen.ListItem

		# initialize: (options) ->
			# if options
			# 	@query = (new Parse.Query(ListItem)).equalTo('list', options.list)

		# We keep the ListItems in sequential order, despite being saved by unordered
		# GUID in the database. This generates the next order number for new items.
		nextOrder: -> if @length then @last().get('order') + 1 else 1

		# list items are sorted by their original insertion order.
		comparator: (item) -> item.get('order')

	Listen.ListCollection = Parse.Collection.extend
		model: Listen.List

	Listen.createItemCollection = (list) ->
		collection = new Listen.ListItemCollection()
		collection.query = new Parse.Query(Listen.ListItem)
		collection.query.equalTo('list', list).include 'user'

		collection

	# return an object containing all the classes defined here.
	# this is a separate step so classes can refer to each other in this file.
	# TODO: make each class a separate file? can you group multiple files into one module?
	# return {
	# 	List : List
	# 	ListItem : ListItem
	# 	ListCollection : ListCollection
	# 	ListItemCollection : ListItemCollection
	# 	PrivacyTypes : PrivacyTypes

	# }