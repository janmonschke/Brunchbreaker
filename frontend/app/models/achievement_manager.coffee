achievements = [
    url: 'asddwevw'
    title: 'Bronze Medal'
    image: 'http://placekitten.com/g/75/75'
    check_on: 'gameFinished'
    constraint: (score) ->
      score > 2000
  ,
    url: '3345ge5g'
    title: 'Orange Belt'
    image: 'http://placekitten.com/g/75/75'
    type: 'single_score'
]

class exports.AchievementManager

  constructor: (user) ->