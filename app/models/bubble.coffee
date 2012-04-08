class exports.Bubble extends Backbone.Model
  defaults:
    highlighted: false
    destroyed: false

  unhighlight: ->
    @set highlighted: false

  highlight: ->
    @set highlighted: true

  isDestroyed: ->
    @get 'destroyed'