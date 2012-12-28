define ['underscore-min', 'parse'], (_) ->  

	# model for a list itself
	List = Parse.Object.extend
		className: 'List'

		defaults: 
			title: ''
			tagline: ''

		initialize: ->

		items: ->
			return @get('items') if @get('items')

			# query = (new Parse.Query(ListItem)).equalTo('list', @)
			# items.fetch()

			@set 'items', new ListItemCollection(list: @)
			# items

		createItem: (options) ->
			_.extend options, list: @
			@items().create options


	# model for an item in a list
	ListItem = Parse.Object.extend
		className: 'ListItem'

		defaults:
			content: ''
			order: 0


	# collection of items in a list (contained within List?)
	ListItemCollection = Parse.Collection.extend
		model: ListItem

		# initialize: (options) ->
			# if options
			# 	@query = (new Parse.Query(ListItem)).equalTo('list', options.list)

		# We keep the ListItems in sequential order, despite being saved by unordered
		# GUID in the database. This generates the next order number for new items.
		nextOrder: -> if @length then @last().get('order') + 1 else 1

		# list items are sorted by their original insertion order.
		comparator: (item) -> item.get('order')

	ListCollection = Parse.Collection.extend
		model: List

	# return an object containing all the classes defined here.
	# this is a separate step so classes can refer to each other in this file.
	# TODO: make each class a separate file? can you group multiple files into one module?
	return {
		List : List
		ListItem : ListItem
		ListCollection : ListCollection
		ListItemCollection : ListItemCollection

		createItemCollection : (list) ->
			collection = new ListItemCollection()
			collection.query = new Parse.Query(ListItem)
			collection.query.equalTo('list', list)

			collection
	}