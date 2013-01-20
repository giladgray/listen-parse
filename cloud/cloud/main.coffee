# List validation!
Parse.Cloud.beforeSave 'List', (request, response) ->
	unless request.object.get('title')
		return response.error('title cannot be empty') 

	console.log 'configuring ACL for List, privacy: ' + request.object.get('privacy')
	acl = request.object.getACL()
	# set public read access based on privacy setting
	switch request.object.get('privacy')
		when 'private'
			acl.setPublicReadAccess(false)
		when 'public'
			acl.setPublicReadAccess(true)
		when 'shared'
			acl.setPublicReadAccess(false)
		else
			return response.error('invalid privacy setting')
	# set public write access based on collaborative
	# NOTE this does not support 'shared' even a little bit
	acl.setPublicWriteAccess(request.object.get('collaborative') or false)
	# update object's ACL and deem the response a success
	request.object.setACL(acl)
	response.success()

# ListItem validation!
Parse.Cloud.beforeSave 'ListItem', (request, response) ->
	# attempt to ensure ListItem always has an ACL, but we're doing this in ListView instead
	unless request.object.getACL()
		acl = new Parse.ACL(request.object.get('user'))
		acl.setPublicReadAccess(true)
		acl.setPublicWriteAccess(false)
		request.object.setACL(acl)
		
	response.success()