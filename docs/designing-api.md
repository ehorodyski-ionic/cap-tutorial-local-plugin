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

TypeScript provides us with definitions for the `OrientationType` and `OrientationLockType` types, which is super convenient! Both types contain the following values, which we'll make use of: `portrait-primary`, `portrait-secondary` (upside down), `landscape-primary` and `landscape-secondary` (upside down).

There are a few notes about our `ScreenOrientation` API:

1. The existing web API's method signature for `lock` is just a string value. We pass in an object with the property `orientation` so our native code can read it as a key-value value.
2. Our plugin's API doesn't provide an event to fire when the orientation changes. We'll hook into JavaScript's `orientationchange` event instead, which has [full support on mobile browsers](https://developer.mozilla.org/en-US/docs/Web/API/Window/orientationchange_event).

## Extending the `PluginRegistry`

Within the TypeScript `@capacitor/core` module exists an interface called `PluginRegistry`. This interface provides typing information for all out-of-the-box Capacitor plugins that come bundled as part of creating a Capacitor application. If we want to provide TypeScript typing information for any local Capacitor plugins, it makes sense to extend this interface. Ultimately, extending the `PluginRegistry` will allow us to reference our plugin like so:

```TypeScript
import { Plugins } from '@capacitor/core';
const { ScreenOrientation } = Plugins;
const current = await ScreenOrientation.orientation();
```

Create a new subfolder `src/plugins`. In this subfolder, create a new file named `screen-orientation.ts`. This file will extend `PluginRegistry` and provide typing information for our plugin:

**`src/plugins/screen-orientation.ts`**

```TypeScript
import "@capacitor/core";

declare module "@capacitor/core" {
  interface ScreenOrientationPlugin {
    orientation(): Promise<{ type: OrientationType; angle: number }>;
    lock(options: { orientation: OrientationLockType }): Promise<void>;
    unlock(): Promise<void>;
  }

  interface PluginRegistry {
    ScreenOrientation: ScreenOrientationPlugin;
  }
}
```

This block of code defines a new interface, `ScreenOrientationPlugin` (containing our plugin's API) and merges a new property `ScreenOrientation` into the existing `PluginRegistry` interface -- thereby extending the `@capacitor/core` module.

We have now completed the API definition for the `ScreenOrientation` plugin! Let's build out a user interface that will call our plugin making it easier for us to test as we implement. Our next step: [Using the Plugin API](/docs/calling-plugin.md).
