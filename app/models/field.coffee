{Bubble} = require 'models/bubble'

class exports.Field extends Backbone.Model
  defaults :
    width : 5
    height : 5
    colors : ['#ff0000', '#00ff00', '#0000ff', '#ffff00']
  
  initialize : ->
    @set 'fields' : @_generate_field()
  
  _generate_field : ->
    fields = []
    color_length = @get('colors').length
    colors = @get 'colors'
    for y in [0..@get 'height']
      fields.push []
      for x in [0..@get 'width']
        curr_color = parseInt(Math.random() * color_length, 10)
        new_bubble = new Bubble color: colors[curr_color]
        fields[y][x] = new_bubble 
        @_bindBubbleEvents new_bubble
    return fields
  
  _bindBubbleEvents: (bubble) ->
    bubble.bind 'hovered', @calculateHighlights

  calculateHighlights: (bubble) =>
    @forEachBubble (currentBubble) =>
      if bubble != currentBubble
        currentBubble.unhighlight()

  forEachBubble: (fn) ->
    return unless fn
    fields = @get 'fields'
    for y in [0..@get 'height']
      for x in [0..@get 'width']
        fn fields[y][x]

  get_neighbours_of: (x, y) ->
    [{x:1, y:2}]