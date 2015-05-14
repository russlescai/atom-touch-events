# atom-touch-events package

Provides touchscreen event handling and gesture capability.

This package exposes the events listed below as part of Atom Services.
For more information about consuming these services in your package, read here: https://atom.io/docs/latest/behind-atom-interacting-with-packages-via-services.

Currently supports gesture events:
* AtomTouchEvents.onDidTouchSwipeUp
* AtomTouchEvents.onDidTouchSwipeDown
* AtomTouchEvents.onDidTouchSwipeLeft
* AtomTouchEvents.onDidTouchSwipeRight
* AtomTouchEvents.onDidTouchPinchIn
* AtomTouchEvents.onDidTouchPinchOut

Provides the following behaviours:
* Touch-based scrolling (horizontal and vertical) for Text Editors
* Touch-based zooming (font size adjustment) for Text Editors

Plans:
* Add more gestures (tap)
* Add more behaviours (more granular pinch to zoom)
* Fix TreeView touch issues
