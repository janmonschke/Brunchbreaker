class exports.BubbleView extends Backbone.View
  className: 'bubble'
  
  events: 
    'hover'  : 'hover'
    'click'  : 'select'

  initialize: (model, @width, @height) -> 
    super
    @model.bind 'change:highlighted', @toggleHighlight
    @model.bind 'change:destroyed', @destroy

  render: ->
    @$el.addClass @model.get 'color'
    @$el.css 
      'width'            : @width
      'height'           : @height
    @

  setPosition: (x, y) ->
    @$el.css
      'left' : "#{x}px"
      'top'  : "#{y}px"
      
  destroy: =>
    @$el.fadeOut 'fast', =>
      @$el.remove()
    
  hover: (event) =>
    @model.trigger 'hovered', @model
    
  select: =>
    @model.trigger 'selected', @model

  toggleHighlight: =>
    highlighted = @model.get 'highlighted'
    if highlighted
      @$el.addClass 'highlighted'
    else
      @$el.removeClass 'highlighted'