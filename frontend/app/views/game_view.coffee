{FieldView} = require 'views/field_view'

class exports.GameView extends Backbone.View

  initialize: ->
    super
    @fieldView = new FieldView model: @model.field

    @model.field.bind 'currentScore', @displayCurrentScore
    @model.bind 'gameOver', @gameOver
    @model.bind 'change:score', @updateScoreView

  render: ->
    @$el.html @fieldView.render().el
    @

  displayCurrentScore: (score) ->
    $('#current_score').text "current score: #{score}"

  updateScoreView: =>
    $('#score').text "total  score: #{@model.get 'score'}"

  gameOver: (score, remainingBubbles) =>