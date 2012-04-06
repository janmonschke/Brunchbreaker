{Field} = require 'models/field'
{FieldView} = require 'views/field_view'
{HomeView} = require 'views/home_view'

class exports.MainRouter extends Backbone.Router
  routes :
    '':     'home'
    'home': 'home'
    
    'new': 'new_game'

  home: ->
    $('body').html new HomeView().render().el

  new_game: ->
    field = new Field()
    fv = new FieldView model: field
    $('#content').html fv.render().el