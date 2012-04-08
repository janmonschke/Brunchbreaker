class exports.BubbleView extends Backbone.View
  className: 'bubble'
  
  events: 
    'hover'  : 'hover'
    'click'  : 'select'

  render: ->
    @$el.css 
      'background-color' : @model.get 'color'
      'width'            : @width
      'height'           : @height
    @
    
  initialize: (model, @width, @height) -> 
    super
    @model.bind 'change:highlighted', @toggleHighlight
    @model.bind 'change:destroyed', @destroy

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
      @$el.css 'background-color' : '#000'
    else
      @$el.css 'background-color' : @model.get 'color'