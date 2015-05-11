AtomTouchEvents = require './atom-touch-events'
AtomTouchScroll = require './atom-touch-scroll'

module.exports = Main =
  activate: (state) ->
    AtomTouchEvents.activate()
    AtomTouchScroll.activate()
