{Field} = require 'models/field'

class exports.Game extends Backbone.Model

  defaults:
    score: 0

  initialize: ->
    @field = new Field()

    @field.bind 'scored', @calculateScore
    @field.bind 'noMoreMoves', @noMoreMoves

  calculateScore: (scoreToAdd) =>
    oldscore = @get 'score'
    @set score: oldscore + scoreToAdd
    @trigger 'newTotalScore', @get('score'), scoreToAdd

  noMoreMoves: (remainingBubbles) =>
    @trigger 'gameOver', @get('score'), remainingBubbles