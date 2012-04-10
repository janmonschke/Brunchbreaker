cradle = require 'cradle'

# establish a cradle connection
connection = new cradle.Connection 'brunchbreaker.iriscouch.com', 80, auth:
  username: 'thebreaker'
  password: 'BRrgEJFtwYgwv33K9t7hqbKQ'

# get the users database
users = connection.database 'users'

class exports.User

  @findOrCreateByFacebookId: (fbData, callback) ->
    # query the view for the user
    users.view 'auth/usersByFbId', { key: fbData.id }, (err, docs) ->
      if err?
        console.log 'user model failed', err
        callback err
        return

      if docs.length > 0
        # the user has been found
        foundDoc = docs[0].value
        foundDoc.id = foundDoc._id # TODO: remove when everyauth.everymodule.userPkey '_id' will be available
        callback null, foundDoc
      else
        # user has not been found, so create it
        if fbData.name?
          newUserDoc = 
            fbId: fbData.id
            name: fbData.name
          User.save newUserDoc, callback
        else
          callback error: 'You need to specify a name to create a user!'

  @findByCouchId: (couchId, callback) ->
    users.get couchId, (err, doc) ->
      doc.id = doc._id
      callback err, doc

  @save: (userData, callback) ->
    saveCb = (err, doc) ->
      if err?
        console.log 'error saving user'
        callback err
        return

      userData.id = doc.id
      userData._id = doc.id
      userData._rev = doc.rev
      callback null, userData

    if userData._id and userData._rev
      users.save userData.id, userData._rev, saveCb
    else
      users.save userData, saveCb

User = exports.User