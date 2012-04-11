(function() {
  var User, connection, cradle, users;

  cradle = require('cradle');

  connection = new cradle.Connection('brunchbreaker.iriscouch.com', 80, {
    auth: {
      username: 'thebreaker',
      password: 'BRrgEJFtwYgwv33K9t7hqbKQ'
    }
  });

  users = connection.database('users');

  exports.User = (function() {

    function User() {}

    User.findOrCreateByFacebookId = function(fbData, callback) {
      return users.view('auth/usersByFbId', {
        key: fbData.id
      }, function(err, docs) {
        var foundDoc, newUserDoc;
        if (err != null) {
          console.log('user model failed', err);
          callback(err);
          return;
        }
        if (docs.length > 0) {
          foundDoc = docs[0].value;
          foundDoc.id = foundDoc._id;
          return callback(null, foundDoc);
        } else {
          if (fbData.name != null) {
            newUserDoc = {
              fbId: fbData.id,
              name: fbData.name
            };
            return User.save(newUserDoc, callback);
          } else {
            return callback({
              error: 'You need to specify a name to create a user!'
            });
          }
        }
      });
    };

    User.findByCouchId = function(couchId, callback) {
      return users.get(couchId, function(err, doc) {
        doc.id = doc._id;
        return callback(err, doc);
      });
    };

    User.save = function(userData, callback) {
      var saveCb;
      saveCb = function(err, doc) {
        if (err != null) {
          console.log('error saving user');
          callback(err);
          return;
        }
        userData.id = doc.id;
        userData._id = doc.id;
        userData._rev = doc.rev;
        return callback(null, userData);
      };
      if (userData._id && userData._rev) {
        return users.save(userData.id, userData._rev, saveCb);
      } else {
        return users.save(userData, saveCb);
      }
    };

    return User;

  })();

  User = exports.User;

}).call(this);
