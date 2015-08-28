# atom-touch-events package

This package provides touchscreen event handling and gesture capability.

This package exposes the events listed below as part of Atom Services.

### Supported behaviours
* Touch-based scrolling (horizontal and vertical) for Text Editors
* Touch-based zooming (font size adjustment) for Text Editors
* Tap sets cursor position without bringing up keyboard

### Supported gesture events
* AtomTouchEvents.onDidTouchSwipeUp
* AtomTouchEvents.onDidTouchSwipeDown
* AtomTouchEvents.onDidTouchSwipeLeft
* AtomTouchEvents.onDidTouchSwipeRight
* AtomTouchEvents.onDidTouchPinchIn
* AtomTouchEvents.onDidTouchPinchOut
* AtomTouchEvents.onDidTouchTap

### Plans
* Add more behaviours (more granular pinch to zoom)
* Fix TreeView touch-related issues

### How To Consume Atom Touch Events

The Atom Service Provider API is used to provide versioned services of these events.

For more information about consuming these services in your package, read here: https://atom.io/docs/latest/behind-atom-interacting-with-packages-via-services.

To consume these events, add the following to your package.json (or the services you need):

```json
"consumedServices": {
  "touch-events": {
    "versions": {
      "^0.21.0": "consumeTouchEvents"
    }
  }
}
```

Then in your main package, implement your consumer function to use the service function:

```coffee
consumeTouchEvents: (touchEvents) ->

  # Subscribe to touch swipe left event
  touchEvents.onDidTouchSwipeLeft (event) ->
    console.log "Swiped left!"
```
