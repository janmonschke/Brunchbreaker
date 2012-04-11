{Bubble} = require 'models/bubble'

# The Field contains all algorithmic logic for the game
# and emit events for important happenings.
# 
# List of events:
# - currentScore [the score the user would currently get if he clicked]
# - scored [the user has scored this amount of points]
# - noMoreMoves [games over with x remaining bubbles]
class exports.Field extends Backbone.Model
  defaults :
    width : 15
    height : 15
    colors : ['color1', 'color2', 'color3', 'color4']
  
  initialize : ->
    @set 'bubbles' : @_generate_field()
  
  _generate_field : ->
    bubbles = []
    color_length = @get('colors').length
    colors = @get 'colors'
    for y in [0..@get('height')-1]
      bubbles.push []
      for x in [0..@get('width')-1]
        curr_color = parseInt(Math.random() * color_length, 10)
        new_bubble = new Bubble color: colors[curr_color], xPos: x, yPos: y
        bubbles[y][x] = new_bubble 
        @_bindBubbleEvents new_bubble
    return bubbles
  
  _bindBubbleEvents: (bubble) ->
    bubble.bind 'hovered', @highlightBubbles
    bubble.bind 'selected', @removeBubbles

  highlightBubbles: (bubble) =>
    # remove the highlight state from all but the current bubble
    @forEachBubble (currentBubble) =>
      if bubble != currentBubble
        currentBubble.unhighlight()

    # find all neighbors
    neighbors = @getNeighborsOf bubble

    @trigger 'currentScore', @calculateScore neighbors

    return if neighbors.length < 2

    for neighbor in neighbors
      neighbor.highlight()

  removeBubbles: (bubble) =>
    neighbors = @getNeighborsOf bubble
    return if neighbors.length < 2
    
    # emit event with the points just scored
    @trigger 'scored', @calculateScore neighbors

    # remove the bubbles from the field
    @clearBubbles neighbors

    # field needs to get redrawn
    @trigger 'invalidate', @get 'bubbles'

    # check if still some possible moves left
    @checkForPossibleMoves()

  clearBubbles: (neighbors) ->
    bubbles = @get 'bubbles'
    for bubble in neighbors
      bubble.set 'destroyed': true
      pos = @getArrayPosition bubble
      bubbles[pos.y][pos.x] = null

    width = @get 'width'
    height = @get 'height'

    # clear all vertical wholes
    for y in [0..height-1]
      for x in [0..width-1]
        bubble = bubbles[y][x]
        y2 = y-1 # go one up
        if not bubble and y2 >= 0
          for y3 in [y2..0]
            bubble = bubbles[y3][x]
            if bubble?
              bubbles[y3+1][x] = bubble
              bubbles[y3][x] = null
              bubble.set
                xPos: x
                yPos: y3+1

    # clear all empty columns
    # 1) count all bubbles in the current column
    for x in [0..width-1]
      bubbleCount = 0
      for y in [0..height-1]
        if bubbles[y][x]?
          bubbleCount++

      # 2) if there are no bubbles in this column
      # move all bubbles from there to the right
      x2 = x-1
      if bubbleCount == 0 and x2 >= 0
        for x3 in [x2..0]
          for y2 in [0..height-1]
            bubble = bubbles[y2][x3]
            bubbles[y2][x3+1] = bubble
            bubbles[y2][x3] = null
            if bubble
              bubble.set
                xPos: x3+1
                yPos: y2

  calculateScore: (bubbles) ->
    bubbles.length * (bubbles.length - 1)

  checkForPossibleMoves: ->
    movesLeft = false
    bubbles = @get 'bubbles'
    runs = 0
    @forEachBubble (bubble, x, y) =>
      # check all 4 neighbors if they have the same colors
      color = bubble.get 'color'
      for y2 in [-1...1]
        break if movesLeft
        for x2 in [-1...1]
          unless x2 == y2 or -x2 == y2 # only check right, underneath, left and above
            currBubble = bubbles[y2+y]?[x2+x]
            if currBubble?
              if currBubble.get('color') == color
                movesLeft = true
                break # breaks the current loop since only one matching neighbor is needed

      return false if movesLeft # this will stop the forEachBubble execution

    unless movesLeft
      remaining = 0
      for arr in bubbles
          for bubble in arr
            remaining++ if bubble?
      @trigger 'noMoreMoves', remaining

  # Execute fn with each bubble
  #
  # Exection will stop if fn returns false
  #
  # @param [Function] fn the function to be executed
  forEachBubble: (fn) ->
    return unless fn
    bubbles = @get 'bubbles'
    stopped = false
    for y in [0..@get('height')-1]
      break if stopped
      for x in [0..@get('width')-1]
        bubble = bubbles[y][x]
        if bubble?
          ret = fn bubbles[y][x], x, y
          if ret == false
            stopped = true
            break 

  # Returns the array position of the current bubble
  # @param [exports.Bubble] bubble the bubble
  getArrayPosition: (bubble) ->
    pos = null
    @forEachBubble (curr, x, y) ->
      if curr is bubble
        pos = x: x, y: y
        return false
    pos

  ### Also includes the current bubble ###
  getNeighborsOf: (bubble) ->
    checklist = [bubble]
    checkcolor = bubble.get 'color'
    result = []
    bubbles = @get 'bubbles'
    width = @get 'width'
    height = @get 'height'

    # a basic flood fill algorithm to get all neighbors
    while checklist.length > 0
      curr = checklist.pop()
      if curr? and curr.get('color') == checkcolor and not _(result).include curr
        result.push curr
        pos = @getArrayPosition curr
        if pos?
          checklist.push bubbles[pos.y][pos.x+1] if pos.x+1 < width # to the right
          checklist.push bubbles[pos.y+1][pos.x] if pos.y+1 < height # underneath
          checklist.push bubbles[pos.y][pos.x-1] if pos.x-1 >= 0 # to the left
          checklist.push bubbles[pos.y-1][pos.x] if pos.y-1 >= 0 # above
    result