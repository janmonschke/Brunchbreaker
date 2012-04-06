class exports.Bubble extends Backbone.Model
  defaults:
    highlighted: false
    selected: false

  unhighlight: ->
    @set highlighted: false
