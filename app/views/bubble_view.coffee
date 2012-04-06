class exports.BubbleView extends Backbone.View
  className : 'bubble'
  
  events : 
    'hover'  : 'hover'
    'touchstart' : 'hover'

  render : ->
    @$el.css 
      'background-color' : @model.get 'color'
      'width'            : @width
      'height'           : @height
    @
    
  initialize: (model, @width, @height) -> 
    super

    @model.bind 'change:highlighted', @toggleHighlight

  setPosition : (x, y) ->
    @$el.css
      'left' : "#{x}px"
      'top'  : "#{y}px"
      
  destroy : ->
    @$el.fadeOut()
    
  hover : =>
    @model.trigger 'hovered', @model
    @model.set highlighted: true
    
  toggleHighlight : =>
    highlighted = @model.get 'highlighted'
    if highlighted
      @$el.css 'background-color' : '#000'
    else
      @$el.css 'background-color' : @model.get 'color'