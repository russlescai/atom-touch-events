AtomTouchEvents = require './atom-touch-events'

module.exports = AtomTouchZoom =
    activate: () ->
      AtomTouchEvents.onDidTouchPinchIn(@touchZoomOut)
      AtomTouchEvents.onDidTouchPinchOut(@touchZoomIn)

    touchZoomIn: (event) ->
      {args, source, distance} = event

      view = source.closest("atom-text-editor")

      if view != null
        if Math.abs(distance) > 2
          fontSize = atom.config.get("editor.fontSize")
          atom.config.set("editor.fontSize", fontSize + 1)

        args.preventDefault()

    touchZoomOut: (event) ->
      {args, source, distance} = event

      view = source.closest("atom-text-editor")

      if view != null
        if Math.abs(distance) > 2
          fontSize = atom.config.get("editor.fontSize")
          atom.config.set("editor.fontSize", fontSize - 1)

        args.preventDefault()
