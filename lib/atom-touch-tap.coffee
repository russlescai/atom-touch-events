AtomTouchEvents = require './atom-touch-events'

###
Module: Atom Touch Tap.
Handles tap using touch events.
###
module.exports = AtomTouchTap =

    # Attach to Atom touch events.
    activate: () ->
      AtomTouchEvents.onDidTouchTap(@touchTap)

    # tap, based on touch event deltas.
    touchTap: (event) ->
      {args, source} = event

      view = source.closest("atom-text-editor")

      if view != null
        args.preventDefault()
        editor = view.getModel()
        screenPosition = view.component.screenPositionForMouseEvent(args.changedTouches[0])
        editor.setCursorScreenPosition screenPosition
        view.focus()
