AtomTouchEvents = require './atom-touch-events'
AtomTouchScroll = require './atom-touch-scroll'
AtomTouchZoom = require './atom-touch-zoom'

module.exports = Main =
  activate: (state) ->
    AtomTouchEvents.activate()
    AtomTouchScroll.activate()
    AtomTouchZoom.activate()
