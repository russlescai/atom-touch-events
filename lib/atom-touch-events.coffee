{Emitter, CompositeDisposable} = require 'atom'

module.exports = AtomTouchEvents =

  activate: () ->
    @emitter = new Emitter
    @subscriptions = new CompositeDisposable

    # Minimum absolute delta value to constitute a swipe
    @minRangeForSwipe = 20

    # Attach event listeners.
    document.addEventListener 'touchstart', AtomTouchEvents.handleTouchStart
    document.addEventListener 'touchmove', AtomTouchEvents.handleTouchMove

  destroy: ->
    @subscriptions.dispose()
    @emitter.dispose(this)

  ###
  Section: Event Subscription
  ###

  onDidTouchSwipeDown: (callback) ->
    @emitter.on 'did-touch-swipe-down', callback

  onDidTouchSwipeUp: (callback) ->
    @emitter.on 'did-touch-swipe-up', callback

  onDidTouchSwipeLeft: (callback) ->
    @emitter.on 'did-touch-swipe-left', callback

  onDidTouchSwipeRight: (callback) ->
    @emitter.on 'did-touch-swipe-right', callback


  # Touch Behaviour Logic
  # The following functions are added to the view
  # to manage touch events and handle them appropriately.

  # Set the initial set of points for touch events.
  # These will be used to determine deltas.
  handleTouchStart: (args) ->
    AtomTouchEvents.startX = args.touches[0].pageX
    AtomTouchEvents.startY = args.touches[0].pageY

  # Touch points have been updated. Determine if constitutes a swipe,
  # and then update the reference points.
  handleTouchMove: (args) ->
    source = args.srcElement

    deltaX = args.touches[0].pageY - AtomTouchEvents.startY
    deltaY = args.touches[0].pageX - AtomTouchEvents.startX
    points = {deltaX, deltaY}

    AtomTouchEvents.startX = args.touches[0].pageX
    AtomTouchEvents.startY = args.touches[0].pageY

    if AtomTouchEvents.isSwipeUp points
      AtomTouchEvents.emitter.emit 'did-touch-swipe-up', {source, deltaX, deltaY}
      args.preventDefault()
    else if AtomTouchEvents.isSwipeDown points
      AtomTouchEvents.emitter.emit 'did-touch-swipe-down', {source, deltaX, deltaY}
      args.preventDefault()
    else if AtomTouchEvents.isSwipeLeft points
      AtomTouchEvents.emitter.emit 'did-touch-swipe-left', {source, deltaX, deltaY}
      args.preventDefault()
    else if AtomTouchEvents.isSwipeRight points
      AtomTouchEvents.emitter.emit 'did-touch-swipe-right', {source, deltaX, deltaY}
      args.preventDefault()

  isSwipeUp: (points) ->
    {deltaX, deltaY} = points
    Math.abs(deltaY) < AtomTouchEvents.minRangeForSwipe and deltaX < 0

  isSwipeDown: (points) ->
    {deltaX, deltaY} = points
    Math.abs(deltaY) < AtomTouchEvents.minRangeForSwipe and deltaX > 0

  isSwipeLeft: (points) ->
    {deltaX, deltaY} = points
    Math.abs(deltaX) < AtomTouchEvents.minRangeForSwipe and deltaY > 0

  isSwipeRight: (points) ->
    {deltaX, deltaY} = points
    Math.abs(deltaX) < AtomTouchEvents.minRangeForSwipe and deltaY > 0
