achievements = new Backbone.Collection [
    id: 1
    url: 'asddwevw'
    title: 'Bronze Medal'
    image: 'http://placekitten.com/g/75/75'
    check_on: 'gameFinished'
    blocker: 'aaa'
    description: 'You earned the bronze medal for scoring more than 2000 points!'
    constraint: (score) ->
      score > 2
  ,
    url: '3345ge5g'
    title: 'Orange Belt'
    image: 'http://placekitten.com/g/75/75'
    type: 'single_score'
]

class exports.AchievementManager

  constructor: (@user) ->
    $.subscribe 'gameOver', @gameOver

  gameOver: (score) =>
    user_achievements = @user.get 'achievements'
    as = achievements.select (achievement) -> achievement.get('check_on') == 'gameFinished'
    for achievement in as
      if not _.contains(user_achievements, achievement.id) and
        achievement.get('constraint')(score) and
        not @user[achievement.get('blocker')]?
          user_achievements.push achievement
          @user.set 'achievements': user_achievements
          @user[achievement.get('blocker')] = true
          $.publish 'achievementUnlocked', [achievement.toJSON()]
    @user.save()