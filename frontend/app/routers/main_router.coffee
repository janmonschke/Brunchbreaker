{Game} = require 'models/game'
{GameView} = require 'views/game_view'
{HomeView} = require 'views/home_view'

class exports.MainRouter extends Backbone.Router
  routes :
    '':     'home'
    '_=_':  'home'
    'home': 'home'
    
    'new': 'new_game'

  initialize: (@user) ->

  home: ->
    @view = new HomeView()
    $('#content').html @view.render().el

  new_game: ->
    game = new Game()
    @view = new GameView model: game
    $('#content').html @view.render().el

    @user.setGame game