AtomTouchEvents = require './atom-touch-events'
AtomTouchScroll = require './atom-touch-scroll'
AtomTouchZoom = require './atom-touch-zoom'

module.exports = Main =
  activate: (state) ->
    AtomTouchEvents.activate()
    AtomTouchScroll.activate()
    AtomTouchZoom.activate()

    # Touch swipe gesture down the screen
  onDidTouchSwipeDown: (callback) ->
    AtomTouchEvents.onDidTouchSwipeDown callback

  # Touch swipe gesture up the screen
  onDidTouchSwipeUp: (callback) ->
    AtomTouchEvents.onDidTouchSwipeUp callback

  # Touch swipe gesture left of the screen
  onDidTouchSwipeLeft: (callback) ->
    AtomTouchEvents.onDidTouchSwipeLeft callback

  # Touch swipe gesture right of the screen
  onDidTouchSwipeRight: (callback) ->
    AtomTouchEvents.onDidTouchSwipeRight callback

  # Touch pinch gesture in towards the center
  onDidTouchPinchIn: (callback) ->
    AtomTouchEvents.onDidTouchPinchIn callback

  # Touch pinch gesture out away from the center
  onDidTouchPinchOut: (callback) ->
    AtomTouchEvents.onDidTouchPinchOut callback
