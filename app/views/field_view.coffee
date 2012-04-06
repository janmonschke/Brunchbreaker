{Bubble} = require 'models/bubble'
{BubbleView} = require 'views/bubble_view'

class exports.FieldView extends Backbone.View
  initialize: ->
    super
    ### Important for calculation of color positions ###
    @color_width = 20
    @color_height = 20
    @color_padding = 3

  render: ->
    colors = @model.get('colors')
    fields = @model.get('fields')
    for y in [0..@model.get('width')-1]
      for x in [0..@model.get('height')-1]
        bv = new BubbleView
          model: fields[y][x]
        , @color_width, @color_height

        bv.setPosition x * @color_width + x * @color_padding , y * @color_height + y * @color_padding
        @$el.append bv.render().el
    @
    
  highlight_neighbour_fields: (x, y)->
    neighbours = @model.get_neighbours x, y