class exports.NotificationHandler

  constructor: ->
    @el = $('#notifications')
    $.subscribe 'achievementUnlocked', @achievementUnlocked

  achievementUnlocked: (achievement) =>
    @showNotification achievement.description

  showNotification: (html) ->
    clearTimeout @timeout
    @el.html html
    @el.slideDown()
    @timeout = setTimeout =>
      @el.slideUp()
    , 3500
