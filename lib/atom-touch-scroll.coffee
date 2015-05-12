AtomTouchEvents = require './atom-touch-events'

module.exports = AtomTouchScroll =

    activate: () ->
      AtomTouchEvents.onDidTouchSwipeUp(@touchScrollUp)
      AtomTouchEvents.onDidTouchSwipeDown(@touchScrollDown)

    # Scrolls up, based on touch event deltas.
    touchScrollUp: (args) ->
      {source, deltaX, deltaY} = args

      if source?.nodeName.toLowerCase() is 'atom-text-editor'
        editor = source.getModel()

        # Determine amount to scroll based on delta value.
        amount = Math.abs(deltaY) * AtomTouchScroll.scrollFactor
        editor.setScrollTop(editor.getScrollTop() + amount)

    # Scrolls down, based on touch event deltas.
    touchScrollDown: (args) ->
      {source, deltaX, deltaY} = args

      if source?.nodeName.toLowerCase() is 'atom-text-editor'
        editor = source.getModel()

        # Determine amount to scroll based on delta value.
        amount = Math.abs(deltaY)
        editor.setScrollTop(editor.getScrollTop() - amount)
