{Emitter, CompositeDisposable} = require 'atom'

###
Module: Atom Touch Events. Exposes various touch-based events.
Attempts to identify gestuers, and provides distances and ranges.
###
module.exports = AtomTouchEvents =

  # Initialise subscriptions and attach event listeners.
  activate: () ->
    @emitter = new Emitter
    @subscriptions = new CompositeDisposable

    # Minimum absolute delta value to constitute a swipe
    @minRangeForSwipe = 20

    # Attach event listeners.
    document.addEventListener 'touchstart', AtomTouchEvents.handleTouchStart
    document.addEventListener 'touchmove', AtomTouchEvents.handleTouchMove

  # Release subscribers.
  destroy: ->
    @subscriptions.dispose()
    @emitter.dispose(this)

  ###
  Section: Event Subscription
  ###

  # Touch swipe gesture down the screen
  onDidTouchSwipeDown: (callback) ->
    @emitter.on 'did-touch-swipe-down', callback

  # Touch swipe gesture up the screen
  onDidTouchSwipeUp: (callback) ->
    @emitter.on 'did-touch-swipe-up', callback

  # Touch swipe gesture left on the screen
  onDidTouchSwipeLeft: (callback) ->
    @emitter.on 'did-touch-swipe-left', callback

  # Touch swipe gesture right on the screen
  onDidTouchSwipeRight: (callback) ->
    @emitter.on 'did-touch-swipe-right', callback

  # Touch pinch gesture in (moving together)
  onDidTouchPinchIn: (callback) ->
    @emitter.on 'did-touch-pinch-in', callback

  # Touch pinch gesture out (moving apart)
  onDidTouchPinchOut: (callback) ->
    @emitter.on 'did-touch-pinch-out', callback


  ###
  Section: Touch Behaviour Logic

  The following functions are added to the view
  to manage touch events and handle them appropriately.
  ###

  # Set the initial set of points for touch events.
  # These will be used to determine deltas.
  handleTouchStart: (args) ->
    AtomTouchEvents.currentArgs = args

  # Touch points have been updated. Determine if constitutes a swipe,
  # and then update the reference points.
  handleTouchMove: (args) ->
    # Identify the element which received the event.
    source = args.srcElement

    # Store previous arguments for comparison of move.
    AtomTouchEvents.startArgs = AtomTouchEvents.currentArgs
    AtomTouchEvents.currentArgs = args

    # Detect events, and emit atom events with parameters.
    if AtomTouchEvents.isSwipeUp()
      {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
      AtomTouchEvents.emitter.emit 'did-touch-swipe-up', {args, source, deltaX, deltaY}
    if AtomTouchEvents.isSwipeDown()
      {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
      AtomTouchEvents.emitter.emit 'did-touch-swipe-down', {args, source, deltaX, deltaY}
    if AtomTouchEvents.isSwipeLeft()
      {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
      AtomTouchEvents.emitter.emit 'did-touch-swipe-left', {args, source, deltaX, deltaY}
    if AtomTouchEvents.isSwipeRight()
      {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
      AtomTouchEvents.emitter.emit 'did-touch-swipe-right', {args, source, deltaX, deltaY}
    if AtomTouchEvents.isPinchIn()
      startDistance = AtomTouchEvents.getStartDistance()
      currentDistance = AtomTouchEvents.getCurrentDistance()
      distance = currentDistance - startDistance
      AtomTouchEvents.emitter.emit 'did-touch-pinch-in', {args, source, distance}
    if AtomTouchEvents.isPinchOut()
      startDistance = AtomTouchEvents.getStartDistance()
      currentDistance = AtomTouchEvents.getCurrentDistance()
      distance = currentDistance - startDistance
      AtomTouchEvents.emitter.emit 'did-touch-pinch-out', {args, source, distance}

  # Find the Delta (X, Y) values for start and current event arguments.
  getDeltaForIndex: (index) ->
    deltaX = AtomTouchEvents.currentArgs.touches[index].pageX - AtomTouchEvents.startArgs.touches[index].pageX
    deltaY = AtomTouchEvents.currentArgs.touches[index].pageY - AtomTouchEvents.startArgs.touches[index].pageY
    {deltaX, deltaY}

  # Find the distance between pinches for the start argument.
  getStartDistance: ->
    if AtomTouchEvents.startArgs.touches.length == 1
      return 0

    x1 = AtomTouchEvents.startArgs.touches[0].pageX
    x2 = AtomTouchEvents.startArgs.touches[1].pageX
    y1 = AtomTouchEvents.startArgs.touches[0].pageY
    y2 = AtomTouchEvents.startArgs.touches[1].pageY
    Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2))

  # Find the distance between pinches for the current argument.
  getCurrentDistance: ->
    if AtomTouchEvents.currentArgs.touches.length == 1
      return 0

    x1 = AtomTouchEvents.currentArgs.touches[0].pageX
    x2 = AtomTouchEvents.currentArgs.touches[1].pageX
    y1 = AtomTouchEvents.currentArgs.touches[0].pageY
    y2 = AtomTouchEvents.currentArgs.touches[1].pageY
    Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2))

  # Determine if the event is a pinch event (two finger)
  isPinch: ->
    AtomTouchEvents.currentArgs.touches.length == 2

  # Determine if the event is a pinch in event
  # (Two finger, distance decreasing)
  isPinchIn: ->
    startDistance = AtomTouchEvents.getStartDistance()
    currentDistance = AtomTouchEvents.getCurrentDistance()
    distance = currentDistance - startDistance

    AtomTouchEvents.isPinch() and distance < 0

  # Determine if the event is a pinch out event
  # (Two finger, distance increasing)
  isPinchOut: ->
    startDistance = AtomTouchEvents.getStartDistance()
    currentDistance = AtomTouchEvents.getCurrentDistance()
    distance = currentDistance - startDistance

    AtomTouchEvents.isPinch() and distance > 0

  # Determine if the event is a swipe event (one finger)
  isSwipe: ->
    AtomTouchEvents.currentArgs.touches.length == 1

  # Determine if the event is a swipe up event (one finger, Y decreasing)
  isSwipeUp: ->
    {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
    AtomTouchEvents.isSwipe() and Math.abs(deltaX) < AtomTouchEvents.minRangeForSwipe and deltaY < 0

  # Determine if the event is a swipe down event (one finger, Y increasing)
  isSwipeDown: ->
    {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
    AtomTouchEvents.isSwipe() and Math.abs(deltaX) < AtomTouchEvents.minRangeForSwipe and deltaY > 0

  # Determine if the event is a swipe left event (one finger, X decreasing)
  isSwipeLeft: ->
    {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
    AtomTouchEvents.isSwipe() and Math.abs(deltaY) < AtomTouchEvents.minRangeForSwipe and deltaX < 0

  # Determine if the event is a swipe right event (one finger, X increasing)
  isSwipeRight: ->
    {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
    AtomTouchEvents.isSwipe() and Math.abs(deltaY) < AtomTouchEvents.minRangeForSwipe and deltaX > 0
