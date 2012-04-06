{Bubble} = require 'models/bubble'
{BubbleView} = require 'views/bubble_view'

class exports.FieldView extends Backbone.View
  initialize: ->
    super
    ### Important for calculation of color positions ###
    @color_width = 20
    @color_height = 20
    @color_padding = 3

    @model.bind 'invalidate', @updatePositions

  render: =>
    console.log 'render'
    @$el.html ''
    @bubbleViews = []
    colors = @model.get('colors')
    bubbles = @model.get('bubbles')

    for y in [0..@model.get('width')-1]
      @bubbleViews.push []
      for x in [0..@model.get('height')-1]
        bubble = bubbles[y][x]
        bv = new BubbleView
          model: bubble
        , @color_width, @color_height

        @setViewPosition bv, x, y
        @$el.append bv.render().el

        @bubbleViews[y][x] = bv
    @

  setViewPosition: (view, x, y) ->
    view.setPosition x * @color_width + x * @color_padding , y * @color_height + y * @color_padding

  updatePositions: (bubbles) =>
    bubbleViews = []
    for y in [0..@model.get('width')-1]
      bubbleViews.push []
      for x in [0..@model.get('height')-1]
        bubbleViews[y][x] = null

    # update all view positions according to the positions in the model
    # why is this done here? could also be moved to the bubble view itself...
    for y in [0..@model.get('width')-1]
      for x in [0..@model.get('height')-1]
        bubbleView = @bubbleViews[y][x]
        if bubbleView? and not bubbleView.model.isDestroyed()
          xPos = bubbleView.model.get 'xPos'
          yPos = bubbleView.model.get 'yPos'
          bubbleViews[yPos][xPos] = bubbleView
          @setViewPosition bubbleView, xPos, yPos

    @bubbleViews = bubbleViews