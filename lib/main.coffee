AtomTouchEvents = require './atom-touch-events'
AtomTouchScroll = require './atom-touch-scroll'
AtomTouchZoom = require './atom-touch-zoom'

module.exports = Main =
  activate: (state) ->
    AtomTouchEvents.activate()
    AtomTouchScroll.activate()
    AtomTouchZoom.activate()

    # Touch swipe gesture down the screen
  onDidTouchSwipeDown: ->
    AtomTouchEvents.onDidTouchSwipeDown

  # Touch swipe gesture up the screen
  onDidTouchSwipeUp: ->
    AtomTouchEvents.onDidTouchSwipeUp

  # Touch swipe gesture left of the screen
  onDidTouchSwipeLeft: ->
    AtomTouchEvents.onDidTouchSwipeLeft

  # Touch swipe gesture right of the screen
  onDidTouchSwipeRight: ->
    AtomTouchEvents.onDidTouchSwipeRight

  # Touch pinch gesture in towards the center
  onDidTouchPinchIn: ->
    AtomTouchEvents.onDidTouchPinchIn

  # Touch pinch gesture out away from the center
  onDidTouchPinchOut: ->
    AtomTouchEvents.onDidTouchPinchOut
