# Description:
#   Control Kodi media player with Hubot
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   KODI_HOST
#   KODI_PORT
#   KODI_USERNAME
#   KODI_PASSWORD
#
# Commands:
#   kodi play <url> - Play media at url, Youtube supported.
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   stratospark

KODI_HOST = process.env.KODI_HOST or 'http://cashewcheese.local'
KODI_PORT = process.env.KODI_PORT or 8080
KODI_USERNAME = process.env.KODI_USERNAME or 'kodi'
KODI_PASSWORD = process.env.KODI_PASSWORD or 'kodi'
ENDPOINT = "#{KODI_HOST}:#{KODI_PORT}/jsonrpc"


`
  function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
    results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
  }
`

module.exports = (robot) ->

  robot.respond /kodi debug/i, (msg) ->
    msg.send "KODI_HOST: #{KODI_HOST}, KODI_PORT: #{KODI_PORT}, KODI_USERNAME: #{KODI_USERNAME}, KODI_PASSWORD: #{KODI_PASSWORD}"
    
  robot.respond /kodi play (.*)/i, (msg) ->
    url = msg.match[1]
    videoid = 0
    # Check if url is a Youtube link
    if url.indexOf('www.youtube.com') != -1
      videoid = getParameterByName("v", url)
      url = "plugin://plugin.video.youtube/?action=play_video&videoid=#{videoid}"
      msg.send "Playing YouTube video"
    else
      msg.send "Playing #{url}"

    data =
      jsonrpc: "2.0",
      id: "1",
      method: "Player.Open",
      params:
        item:
          file: url
    data = JSON.stringify(data)
    authString = 'Basic ' + new Buffer("#{KODI_USERNAME}:#{KODI_PASSWORD}").toString('base64')
    msg
      .http(ENDPOINT)
      .header('Content-Type', 'application/json')
      .header('Authorization', authString)
      .post(data) (err, res, body) ->
        if err
          msg.send "Error: #{err}"

  # robot.hear /badger/i, (res) ->
  #   res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
  #
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
  #robot.hear /I like pie/i, (res) ->
  #  res.emote "makes a freshly baked pie"
  #
  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
  # answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING
  #
  # robot.respond /what is the answer to the ultimate question of life/, (res) ->
  #   unless answer?
  #     res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
  #     return
  #   res.send "#{answer}, but what is the question?"
  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
  # robot.error (err, res) ->
  #   robot.logger.error "DOES NOT COMPUTE"
  #
  #   if res?
  #     res.reply "DOES NOT COMPUTE"
  #
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
