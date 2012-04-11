express = require('express')
everyauth = require('everyauth')
Promise = everyauth.Promise

{User} = require './user'

app = express.createServer()

everyauth.facebook
  .appId('247137018715788')
  .appSecret('cd5e7acc89c0cb3109551c97debe631c')
  .handleAuthCallbackError((req, res) -> 
    console.log 'auth handleAuthCallbackError'
  )
  .findOrCreateUser( (session, accessToken, accessTokExtra, fbUserMetadata) ->
    promise = @Promise()
    # find the user by its Facebook ID and fulfill the promise
    User.findOrCreateByFacebookId fbUserMetadata, (err, user) ->
      if err?
        promise.fail err
      else
        promise.fulfill user
    promise
  )
  .redirectPath '/'

app.configure ->
  app.use express.methodOverride()
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session secret: '9s8dfhosn0ddsf9wbg3sv435hhd2g4'
  app.use everyauth.middleware()
  app.use app.router
  app.set 'view engine', 'jade'
  app.set 'views', __dirname + '/views'
  app.set 'view options', layout: false
  app.use express.static __dirname + '/frontend/build'

everyauth.helpExpress app
everyauth.everymodule.findUserById (id, callback) ->
  User.findByCouchId id, callback

# is this method needed?
# when the user is in the req var then it is normally complete
# good for a test run
app.get '/user/:id', (req, res) ->
  # user needs to be logged in and to have the same id as requested
  # otherwise a user would be able to get all information of all users
  if req.user? and req.user.fbId == req.params.id
    User.findOrCreateByFacebookId { id: req.params.id }, (err, user) ->
      if err?
        res.send { error: 'Error fetching the user.' }, 404
      else
        res.send user
  else
    res.send { error: 'You are not allowed to access this information!' }, 403

app.get '/', (req, res) ->
  res.render 'index'

app.listen process.env['app_port'] or 3000