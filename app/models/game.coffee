{Field} = require 'models/field'

class exports.Game extends Backbone.Model

  initialize: ->
    @field = new Field()