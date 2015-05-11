AtomTouchEvents = require './atom-touch-events'

module.exports = AtomTouchScroll =

    activate: () ->
      AtomTouchEvents.onDidTouchSwipeUp(@touchScrollUp)
      AtomTouchEvents.onDidTouchSwipeDown(@touchScrollDown)

    # Scrolls up, based on touch event deltas.
    touchScrollUp: (args) ->
      {source, deltaX, deltaY} = args

      for textEditor in atom.workspace.getTextEditors()
        if source == textEditor
          # Determine amount to scroll based on delta value with a factor of 5.
          amount = Math.abs(deltaY) * 5
          source.setScrollTop(source.getScrollTop() + amount)

    # Scrolls down, based on touch event deltas.
    touchScrollDown: (args) ->
      {source, deltaX, deltaY} = args

      for textEditor in atom.workspace.getTextEditors()
        if source == textEditor
          # Determine amount to scroll based on delta value with a factor of 5.
          amount = Math.abs(deltaY) * 5
          source.setScrollTop(source.getScrollTop() - amount)
