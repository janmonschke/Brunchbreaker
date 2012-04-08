{Field} = require 'models/field'
{FieldView} = require 'views/field_view'

class exports.GameView extends Backbone.View

  initialize: ->
    @field = new Field()
    @fieldView = new FieldView model: @field

    $.subscribe 'currentScore', @displayCurrentScore
    $.subscribe 'newTotalScore', @updateScoreView

  render: ->
    @$el.html @fieldView.render().el
    @

  displayCurrentScore: (score) ->
    $('#current_score').text "current score: #{score}"

  updateScoreView: (newTotalScore) ->
    $('#score').text "total  score: #{newTotalScore}"