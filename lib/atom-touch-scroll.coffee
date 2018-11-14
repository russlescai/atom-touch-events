AtomTouchEvents = require './atom-touch-events'

###
Module: Atom Touch Scroll.
Scrolls horizontally and vertically using touch events.
###
module.exports = AtomTouchScroll =

    # Attach to Atom touch events.
    activate: () ->
      AtomTouchEvents.onDidTouchSwipeUp(@touchScrollUp)
      AtomTouchEvents.onDidTouchSwipeDown(@touchScrollDown)
      AtomTouchEvents.onDidTouchSwipeLeft(@touchScrollLeft)
      AtomTouchEvents.onDidTouchSwipeRight(@touchScrollRight)

    # Scrolls up, based on touch event deltas.
    touchScrollUp: (event) ->
      {args, source, deltaX, deltaY} = event

      view = source.closest("atom-text-editor")

      if view != null
        # Determine amount to scroll based on delta value.
        amount = Math.abs(deltaY)
        view.setScrollTop(view.getScrollTop() + amount)

        args.preventDefault()

    # Scrolls down, based on touch event deltas.
    touchScrollDown: (event) ->
      {args, source, deltaX, deltaY} = event

      view = source.closest("atom-text-editor")

      if view != null
        # Determine amount to scroll based on delta value.
        amount = Math.abs(deltaY)
        view.setScrollTop(view.getScrollTop() - amount)

        args.preventDefault()

    # Scrolls left, based on touch event deltas.
    touchScrollLeft: (event) ->
      {args, source, deltaX, deltaY} = event

      view = source.closest("atom-text-editor")

      if view != null
        # Determine amount to scroll based on delta value.
        amount = Math.abs(deltaX)
        view.setScrollLeft(view.getScrollLeft() + amount)

        args.preventDefault()

    # Scrolls left, based on touch event deltas.
    touchScrollRight: (event) ->
      {args, source, deltaX, deltaY} = event

      view = source.closest("atom-text-editor")

      if view != null
        # Determine amount to scroll based on delta value.
        amount = Math.abs(deltaX)
        view.setScrollLeft(view.getScrollLeft() - amount)

        args.preventDefault()
