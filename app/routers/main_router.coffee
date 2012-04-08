{Game} = require 'models/game'
{GameView} = require 'views/game_view'
{HomeView} = require 'views/home_view'

class exports.MainRouter extends Backbone.Router
  routes :
    '':     'home'
    'home': 'home'
    
    'new': 'new_game'

  home: ->
    $('body').html new HomeView().render().el

  new_game: ->
    game = new Game()
    gv = new GameView model: game
    $('#content').html gv.render().el