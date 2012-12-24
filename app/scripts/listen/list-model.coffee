define ['parse'], () ->  
	# model for an item in a list
	ListItem = Parse.Object.extend
		className: 'ListItem'

	# model for a list itself
	List = Parse.Object.extend
		className: 'List'

		# initialize: ->
			# @set 'collection'

	# collection of items in a list (contained within List?)
	ListCollection = Parse.Collection.extend
		model: ListItem

		# We keep the ListItems in sequential order, despite being saved by unordered
		# GUID in the database. This generates the next order number for new items.
		nextOrder: -> if @length then @last().get('order') + 1 else 1

		# list items are sorted by their original insertion order.
		comparator: (item) -> item.get('order')

	# return an object containing all the classes defined here.
	# this is a separate step so classes can refer to each other in this file.
	# TODO: make each class a separate file? can you group multiple files into one module?
	return {
		List : List
		ListItem : ListItem
		ListCollection : ListCollection
	}