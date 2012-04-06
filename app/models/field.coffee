{Bubble} = require 'models/bubble'

class exports.Field extends Backbone.Model
  defaults :
    width : 15
    height : 15
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
    bubble.bind 'hovered', @highlightBubbles

  highlightBubbles: (bubble) =>
    # remove the highlight state from all but the current bubble
    @forEachBubble (currentBubble) =>
      if bubble != currentBubble
        currentBubble.unhighlight()

    # find all neighbors
    neighbors = @getNeighborsOf bubble

    console.log "TODO: find a good way for showing the score"
    $('#score').text "score: #{neighbors.length * (neighbors.length-1)}"

    return if neighbors.length < 2

    for neighbor in neighbors
      neighbor.highlight()

  ### Execute fn with each bubble ###
  forEachBubble: (fn) ->
    return unless fn
    fields = @get 'fields'
    for y in [0..@get 'height']
      for x in [0..@get 'width']
        fn fields[y][x], x, y

  ### Returns the array position of the current bubble ###
  getArrayPosition: (bubble) ->
    pos = x: -1, y: -1
    @forEachBubble (curr, x, y) ->
      if curr is bubble
        pos.x = x
        pos.y = y
    pos

  ### Also includes the current bubble ###
  getNeighborsOf: (bubble) ->
    checklist = [bubble]
    checkcolor = bubble.get 'color'
    result = []
    fields = @get 'fields'
    width = @get 'width'
    height = @get 'height'

    # a basic flood fill algorithm to get all neighbors
    while checklist.length > 0
      curr = checklist.pop()
      if curr? and curr.get('color') == checkcolor and not _(result).include curr
        result.push curr
        pos = @getArrayPosition curr
        checklist.push fields[pos.y][pos.x+1] if pos.x+1 < width # to the right
        checklist.push fields[pos.y+1][pos.x] if pos.y+1 < height # underneath
        checklist.push fields[pos.y][pos.x-1] if pos.x-1 >= 0 # to the left
        checklist.push fields[pos.y-1][pos.x] if pos.y-1 >= 0 # above
    result