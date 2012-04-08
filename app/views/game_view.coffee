{Game} = require 'models/game'
{FieldView} = require 'views/field_view'

class exports.GameView extends Backbone.View

  initialize: ->
    @game = new Game()
    @fieldView = new FieldView model: @game.field

    $.subscribe 'currentScore', @displayCurrentScore
    
    @game.bind 'change:score', @updateScoreView

  render: ->
    @$el.html @fieldView.render().el
    @

  displayCurrentScore: (score) ->
    $('#current_score').text "current score: #{score}"

  updateScoreView: =>
    $('#score').text "total  score: #{@game.get 'score'}"