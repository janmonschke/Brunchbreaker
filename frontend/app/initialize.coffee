{BrunchApplication} = require 'helpers'
{MainRouter} = require 'routers/main_router'
{HomeView} = require 'views/home_view'
{User} = require 'models/user'

class Application extends BrunchApplication
  # This callback would be executed on document ready event.
  # If you have a big application, perhaps it's a good idea to
  # group things by their type e.g. `@views = {}; @views.home = new HomeView`.
  initialize: ->
    if window.user_hash
      @user = new User window.user_hash
      delete window.user_hash
      $('#user_hash').remove()
    else
      @user = new User()
    @router = new MainRouter @user
    @homeView = new HomeView
    @isMobileDevice = navigator.userAgent.match(
      /(Android|webOS|iPhone|Ipod|iPad|BlackBerry|Windows Phone|ZuneWP7)/
    )?.length > 0

window.BrunchBreaker = new Application()