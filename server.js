(function() {
  var Promise, User, app, everyauth, express;

  express = require('express');

  everyauth = require('everyauth');

  Promise = everyauth.Promise;

  User = require('./user').User;

  app = express.createServer();

  everyauth.facebook.appId('247137018715788').appSecret('cd5e7acc89c0cb3109551c97debe631c').handleAuthCallbackError(function(req, res) {
    return console.log('auth handleAuthCallbackError');
  }).findOrCreateUser(function(session, accessToken, accessTokExtra, fbUserMetadata) {
    var promise;
    promise = this.Promise();
    User.findOrCreateByFacebookId(fbUserMetadata, function(err, user) {
      if (err != null) {
        return promise.fail(err);
      } else {
        return promise.fulfill(user);
      }
    });
    return promise;
  }).redirectPath('/');

  app.configure(function() {
    app.use(express.methodOverride());
    app.use(express.bodyParser());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: '9s8dfhosn0ddsf9wbg3sv435hhd2g4'
    }));
    app.use(everyauth.middleware());
    app.use(app.router);
    app.set('view engine', 'jade');
    app.set('views', __dirname + '/views');
    app.set('view options', {
      layout: false
    });
    return app.use(express.static(__dirname + '/frontend/build'));
  });

  everyauth.helpExpress(app);

  everyauth.everymodule.findUserById(function(id, callback) {
    return User.findByCouchId(id, callback);
  });

  app.get('/user/:id', function(req, res) {
    if ((req.user != null) && req.user.fbId === req.params.id) {
      return User.findOrCreateByFacebookId({
        id: req.params.id
      }, function(err, user) {
        if (err != null) {
          return res.send({
            error: 'Error fetching the user.'
          }, 404);
        } else {
          return res.send(user);
        }
      });
    } else {
      return res.send({
        error: 'You are not allowed to access this information!'
      }, 403);
    }
  });

  app.get('/', function(req, res) {
    return res.render('index');
  });

  app.listen(process.env['app_port'] || 3000);

}).call(this);
