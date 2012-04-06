class exports.HomeView extends Backbone.View
  id: 'home-view'
  template: require('views/templates/home')

  render: ->
    $(@el).html @template()
    @