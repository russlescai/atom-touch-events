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
    document.addEventListener 'touchend', AtomTouchEvents.handleTouchEnd

  # Release subscribers.
  destroy: ->
    @subscriptions.dispose()
    @emitter.dispose(this)

  ###
  Section: Event Subscription
  ###

  # Touch swipe gesture down the screen
  onDidTouchSwipeDown: (callback, done) ->
    AtomTouchEvents.addEventListener 'did-touch-swipe-down', callback, done

  # Touch swipe gesture up the screen
  onDidTouchSwipeUp: (callback, done) ->
    AtomTouchEvents.addEventListener 'did-touch-swipe-up', callback, done

  # Touch swipe gesture left on the screen
  onDidTouchSwipeLeft: (callback, done) ->
    AtomTouchEvents.addEventListener 'did-touch-swipe-left', callback, done

  # Touch swipe gesture right on the screen
  onDidTouchSwipeRight: (callback, done) ->
    AtomTouchEvents.addEventListener 'did-touch-swipe-right', callback, done

  # Touch pinch gesture in (moving together)
  onDidTouchPinchIn: (callback, done) ->
    AtomTouchEvents.addEventListener 'did-touch-pinch-in', callback, done

  # Touch pinch gesture out (moving apart)
  onDidTouchPinchOut: (callback, done) ->
    AtomTouchEvents.addEventListener 'did-touch-pinch-out', callback, done

  # Touch tap gesture
  onDidTouchTap: (callback) ->
    AtomTouchEvents.addEventListener 'did-touch-tap', callback


  # Add an event listener for one of the supported events.
  # callback is called during the touchmove event
  # done is called on the touchend event
  addEventListener: (name, callback, done) ->
    disposables = [AtomTouchEvents.emitter.on name, callback]
    if done?
      disposables.push AtomTouchEvents.emitter.on name + '-end', done
    new CompositeDisposable disposables...

  ###
  Section: Touch Behaviour Logic

  The following functions are added to the view
  to manage touch events and handle them appropriately.
  ###

  # Set the initial set of points for touch events.
  # These will be used to determine deltas.
  handleTouchStart: (args) ->
    # set both to prevent exceptions in getDeltaForIndex, getStartDistance
    # and getCurrentDistance when no touchmove is triggered before touchend
    AtomTouchEvents.baseArgs = AtomTouchEvents.startArgs = AtomTouchEvents.currentArgs = args

  # Touch points have been updated. Determine if constitutes a swipe,
  # and then update the reference points.
  handleTouchMove: (args) ->
    # Identify the element which received the event.
    source = args.srcElement

    # Store previous arguments for comparison of move.
    AtomTouchEvents.startArgs = AtomTouchEvents.currentArgs
    AtomTouchEvents.currentArgs = args

    elapsedTime = AtomTouchEvents.currentArgs.timeStamp - AtomTouchEvents.startArgs.timeStamp

    # Detect events, and emit atom events with parameters.
    if AtomTouchEvents.isSwipeUp()
      {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
      AtomTouchEvents.emitter.emit 'did-touch-swipe-up', {args, source, deltaX, deltaY, elapsedTime}
    if AtomTouchEvents.isSwipeDown()
      {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
      AtomTouchEvents.emitter.emit 'did-touch-swipe-down', {args, source, deltaX, deltaY, elapsedTime}
    if AtomTouchEvents.isSwipeLeft()
      {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
      AtomTouchEvents.emitter.emit 'did-touch-swipe-left', {args, source, deltaX, deltaY, elapsedTime}
    if AtomTouchEvents.isSwipeRight()
      {deltaX, deltaY} = AtomTouchEvents.getDeltaForIndex 0
      AtomTouchEvents.emitter.emit 'did-touch-swipe-right', {args, source, deltaX, deltaY, elapsedTime}
    if AtomTouchEvents.isPinchIn()
      startDistance = AtomTouchEvents.getStartDistance()
      currentDistance = AtomTouchEvents.getCurrentDistance()
      distance = currentDistance - startDistance
      AtomTouchEvents.emitter.emit 'did-touch-pinch-in', {args, source, distance, elapsedTime}
    if AtomTouchEvents.isPinchOut()
      startDistance = AtomTouchEvents.getStartDistance()
      currentDistance = AtomTouchEvents.getCurrentDistance()
      distance = currentDistance - startDistance
      AtomTouchEvents.emitter.emit 'did-touch-pinch-out', {args, source, distance, elapsedTime}

  handleTouchEnd: (args) ->
    source = args.srcElement

    elapsedTime = args.timeStamp - AtomTouchEvents.currentArgs.timeStamp

    if AtomTouchEvents.isTap(args)
      AtomTouchEvents.emitter.emit 'did-touch-tap',  {args,source, elapsedTime}
    if AtomTouchEvents.isSwipeUp()
      AtomTouchEvents.emitter.emit 'did-touch-swipe-up-end', {args, source, elapsedTime}
    if AtomTouchEvents.isSwipeDown()
      AtomTouchEvents.emitter.emit 'did-touch-swipe-down-end', {args, source, elapsedTime}
    if AtomTouchEvents.isSwipeLeft()
      AtomTouchEvents.emitter.emit 'did-touch-swipe-left-end', {args, source, elapsedTime}
    if AtomTouchEvents.isSwipeRight()
      AtomTouchEvents.emitter.emit 'did-touch-swipe-right-end', {args, source, elapsedTime}
    if AtomTouchEvents.isPinchIn()
      AtomTouchEvents.emitter.emit 'did-touch-pinch-in-end', {args, source, elapsedTime}
    if AtomTouchEvents.isPinchOut()
      AtomTouchEvents.emitter.emit 'did-touch-pinch-out-end', {args, source, elapsedTime}

  # Find the Delta (X, Y) values for start and current event arguments.
  getDeltaForIndex: (index) ->
    deltaX = AtomTouchEvents.currentArgs.changedTouches[index].pageX - AtomTouchEvents.startArgs.changedTouches[index].pageX
    deltaY = AtomTouchEvents.currentArgs.changedTouches[index].pageY - AtomTouchEvents.startArgs.changedTouches[index].pageY
    {deltaX, deltaY}

  # Find the distance between pinches for the start argument.
  getStartDistance: ->
    if AtomTouchEvents.startArgs.changedTouches.length == 1
      return 0

    x1 = AtomTouchEvents.startArgs.changedTouches[0].pageX
    x2 = AtomTouchEvents.startArgs.changedTouches[1].pageX
    y1 = AtomTouchEvents.startArgs.changedTouches[0].pageY
    y2 = AtomTouchEvents.startArgs.changedTouches[1].pageY
    Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2))

  # Find the distance between pinches for the current argument.
  getCurrentDistance: ->
    if AtomTouchEvents.currentArgs.changedTouches.length == 1
      return 0

    x1 = AtomTouchEvents.currentArgs.changedTouches[0].pageX
    x2 = AtomTouchEvents.currentArgs.changedTouches[1].pageX
    y1 = AtomTouchEvents.currentArgs.changedTouches[0].pageY
    y2 = AtomTouchEvents.currentArgs.changedTouches[1].pageY
    Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2))

  # Determine if the event is a tap event
  isTap: (args) ->
    totalElapsedTime = args.timeStamp - AtomTouchEvents.baseArgs.timeStamp
    totalElapsedTime < 200


  # Determine if the event is a pinch event (two finger)
  isPinch: ->
    AtomTouchEvents.currentArgs.changedTouches.length == 2

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
    AtomTouchEvents.currentArgs.changedTouches.length == 1

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
