(function() {

  Parse.Cloud.beforeSave('List', function(request, response) {
    var acl;
    if (!request.object.get('title')) {
      return response.error('title cannot be empty');
    }
    console.log('configuring ACL for List, privacy: ' + request.object.get('privacy'));
    acl = request.object.getACL();
    switch (request.object.get('privacy')) {
      case 'private':
        acl.setPublicReadAccess(false);
        break;
      case 'public':
        acl.setPublicReadAccess(true);
        break;
      case 'shared':
        acl.setPublicReadAccess(false);
        break;
      default:
        return response.error('invalid privacy setting');
    }
    acl.setPublicWriteAccess(request.object.get('collaborative') || false);
    request.object.setACL(acl);
    return response.success();
  });

  Parse.Cloud.beforeSave('ListItem', function(request, response) {
    var acl;
    if (!request.object.getACL()) {
      acl = new Parse.ACL(request.object.get('user'));
      acl.setPublicReadAccess(true);
      acl.setPublicWriteAccess(false);
      request.object.setACL(acl);
    }
    return response.success();
  });

}).call(this);
