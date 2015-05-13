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
    touchScrollUp: (args) ->
      {source, deltaX, deltaY} = args

      editor = atom.workspace.getActiveTextEditor()

      # Determine amount to scroll based on delta value.
      amount = Math.abs(deltaY)
      editor.setScrollTop(editor.getScrollTop() + amount)

    # Scrolls down, based on touch event deltas.
    touchScrollDown: (args) ->
      {source, deltaX, deltaY} = args

      editor = atom.workspace.getActiveTextEditor()

      # Determine amount to scroll based on delta value.
      amount = Math.abs(deltaY)
      editor.setScrollTop(editor.getScrollTop() - amount)

    # Scrolls left, based on touch event deltas.
    touchScrollLeft: (args) ->
      {source, deltaX, deltaY} = args

      editor = atom.workspace.getActiveTextEditor()

      # Determine amount to scroll based on delta value.
      amount = Math.abs(deltaX)
      editor.setScrollLeft(editor.getScrollLeft() + amount)

    # Scrolls left, based on touch event deltas.
    touchScrollRight: (args) ->
      {source, deltaX, deltaY} = args

      editor = atom.workspace.getActiveTextEditor()

      # Determine amount to scroll based on delta value.
      amount = Math.abs(deltaX)
      editor.setScrollLeft(editor.getScrollLeft() - amount)
