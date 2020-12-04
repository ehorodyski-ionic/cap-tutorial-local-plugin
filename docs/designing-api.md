# Designing the Plugin API

The first (and most critical) step is to define an API for the `ScreenOrientation` plugin. The plugin's API is the contract that we'll adhere to when building out each platform's specific implementation.

In this step we'll define the plugin API and add TypeScript definitions for it by extending Capacitor's `PluginRegistry`. This will give us the nicities TypeScript provides with code completion and type checking.

## The `ScreenOrientation` API

Believe it or not, modern web browsers already have a decent amount of support for screen orientation functionality. You'll find this to be a common thread when building Capacitor applications; a feature that requires custom native code today becomes a web API tomorrow.

Before building out a plugin for a particular feature, it's recommended to check out sites such as [What Web Can Do Today](https://whatwebcando.today/) to see if you even need to a plugin to begin with!

Taking a look at the web [Screen Orientation API](https://whatwebcando.today/screen-orientation.html), we can see that there is not broad support for all of the existing API's functionality, so it makes a good candidate to build a plugin for.

We'll model our plugin's API after the web Screen Orientation API:

| Method Name   | Input Parameters                       | Return Value                                       |
| ------------- | -------------------------------------- | -------------------------------------------------- |
| `orientation` |                                        | `Promise<{ type: OrientationType; angle: number}>` |
| `lock`        | `{ orientation: OrientationLockType }` | `Promise<void>`                                    |
| `unlock`      |                                        | `Promise<void>`                                    |

TypeScript provides us with definitions for the `OrientationType` and `OrientationLockType` types, which is super convenient!

Notice that our API doesn't provide an event to fire when the orientation changes. We'll hook into JavaScript's `orientationchange` event instead, which has [full support on mobile browsers](https://developer.mozilla.org/en-US/docs/Web/API/Window/orientationchange_event).
