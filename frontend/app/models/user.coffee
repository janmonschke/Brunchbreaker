{AchievementManager} = require 'models/achievement_manager'

class exports.User extends Backbone.Model
  url: '/user'
  defaults: ->
    name: "Anonymus"
    achievements: []
    accumulatedScore: 0 # all end scores added up
    highestScore: 0 # highest score in a single game
    highestClickScore: 0 # highest score with a single click
    gamesPlayed: 0 # amount of games played
    mobileGamesPlayed: 0 # amount of games played on mobile device
    columnsKilled: 0 # amount of vertical columns killed
    
  initialize: ->
    super
    @achievementManager = new AchievementManager @

  setGame: (@game) ->
    @game.bind 'newTotalScore', @scored
    @game.bind 'gameOver', @gameOver

  hasAchievement: (achievementUrl) ->
    achievements = @get 'achievements'
    return achievements[achievementUrl]?

  scored: (newTotalScore, scored) =>
    highestClickScore = @get 'highestClickScore'
    gamesPlayed = @get 'gamesPlayed'

    if scored > highestClickScore
      @set 'highestClickScore': scored
      $.publish 'newHighestClickScore', [scored] if gamesPlayed > 0
      @save()

  gameOver: (score, bubblesLeft) =>
    # update the variables that have to always get an update
    @set
      'gamesPlayed': @get('gamesPlayed') + 1
      'accumulatedScore': @get('accumulatedScore') + score

    # set the new highest score if more than ever before
    highestScore = @get 'highestScore'
    if score > highestScore
      @set 'highestScore': score
      $.publish 'newHighestScore', [score]

    @save()

  save: ->