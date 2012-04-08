{Field} = require 'models/field'

class exports.Game extends Backbone.Model

  defaults:
    score: 0

  initialize: ->
    @field = new Field()

    $.subscribe 'scored', @calculateScore

  calculateScore: (scoreToAdd) =>
    oldscore = @get 'score'
    @set score: oldscore + scoreToAdd
    $.publish 'newTotalScore', [@get 'score']