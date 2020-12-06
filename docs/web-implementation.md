# The Web Implementation

Our Capacitor application is currently being served on the web (if yours isn't run `ionic serve`) it makes sense to tackle the web implementation of our `ScreenOrientation` plugin first. We'll just be wrapping the Screen Orientation Web API to adhere to the plugin API we defined in the [Designing the Plugin API](/docs/designing-api.md) step.

## Implementing the `WebPlugin` Class

The web implementation of a Capacitor plugin needs to be a subclass of the `WebPlugin` class contained within the `@capacitor/core` module.

Create a new file in `src/plugins` named `ScreenOrientationWeb.ts` and populate it with the following code:

**`src/plugins/ScreenOrientationWeb.ts`**

```TypeScript
import { ScreenOrientationPlugin, WebPlugin } from "@capacitor/core";

export class ScreenOrientationWeb
  extends WebPlugin
  implements ScreenOrientationPlugin {

  constructor() {
    super({
      name: "ScreenOrientation",
      platforms: ["web"],
    });
  }

}
```

Our `ScreenOrientationWeb` class extends `WebPlugin` which needs to provide some metadata to Capacitor by-way of supplying a configuration object to the superclass's constructor:

- `name` - The name of the plugin, it needs to match the name we used when extending the `PluginRegistry` interface.
- `platforms` - The list of platforms this implementation will be used for.

The `platforms` configuration option is the more powerful of the two. Let's imagine a scenario where a new Web API is created that is supported on desktop and Android, but iOS does not yet have an implementation for it yet. We could set the `platforms` option to `["web", "android"]` and our web implementation of the plugin will be called on desktop and Android platforms, and we'd supply only a native iOS implementation since it is not supported. Pretty neat!

Make note that we're also implementing the `ScreenOrientationPlugin` interface which binds our plugin's web implementation with the plugin API defined in `src/plugins/screen-orientation.ts`.

## Registering the Web Implementation

To register the `ScreenOrientationWeb` implementation with Capacitor, we take advantage of the `registerWebPlugin` function contained within the `@capacitor/core` module. It's best to register our web implementation as early as possible, so let's do so in `src/index.tsx`:

**`src/index.tsx`**

```TypeScript
// Imports for Capacitor and our plugin's web implementation.
import { registerWebPlugin } from '@capacitor/core';
import { ScreenOrientationWeb } from './plugins/ScreenOrientationWeb';

import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import * as serviceWorker from './serviceWorker';

// Registering an instance of ScreenOrientationWeb with Capacitor.
registerWebPlugin(new ScreenOrientationWeb());

ReactDOM.render(<App />, document.getElementById('root'));
serviceWorker.unregister();
```

We simply import `registerWebPlugin` from `@capacitor/core`, our `ScreenOrientationWeb` class, and register the plugin. The rest of the code is specific to React and does not need to be expanded upon.

With the web implementation class registered with our Capacitor application, let's build out the actual functionality.

## Implementing the `ScreenOrientationPlugin` API

The following methods will be added to the `ScreenOrientationWeb` class in `src/plugins/ScreenOrientationWeb.ts`.

### Getting the Current Orientation

The Web's ScreenOrientation API method for [getting the current screen orientation](https://developer.mozilla.org/en-US/docs/Web/API/ScreenOrientation) is a synchronous operation that returns the current `OrientationType`, the document's current orientation andle, and an event handler to call whenever the screen changes orientation.

We've decided that we're just going to return the `OrientationType` and `angle` properties for our API:

**`src/plugins/ScreenOrientationWeb.ts`**

```TypeScript
async orientation(): Promise<{ type: OrientationType; angle: number }> {
  return window.screen.orientation;
}
```

The real change we're making here is making the Web's ScreenOrientation API call asynchronous, since all calls to our native implementations need to be asynchronous operations. The typing we're providing will also prevent anyone from attempting to use the `onchange` event handler property that is returned with `window.screen.orientation`.

### Locking the Screen Orientation

The Web ScreenOrientation API`s [locking method](https://developer.mozilla.org/en-US/docs/Web/API/ScreenOrientation/lock) is not well supported on desktop browsers, so we'll add a try-catch statement to suppress any errors if we cannot lock the screen orientation on the web:

**`src/plugins/ScreenOrientationWeb.ts`**

```TypeScript
async lock(options: { orientation: OrientationLockType }): Promise<void> {
  try {
    await window.screen.orientation.lock(options.orientation);
    return;
  } catch (error) {
    // Suppress any errors if we can't lock on the web.
    return;
  }
}
```

Same pattern here, just a light wrapper around the Web ScreenOrientation API.

### Unlocking the Screen Orientation

No considerations need to be made with wrapping the Web ScreenOrientation API's [unlock](https://developer.mozilla.org/en-US/docs/Web/API/ScreenOrientation/unlock) method, so we'll just simply return it:

**`src/plugins/ScreenOrientationWeb.ts`**

```TypeScript
async unlock(): Promise<void> {
  return window.screen.orientation.unlock();
}
```

## Test it out!

It's time to test out our web implementation. I recommend using your browser's development tools to emulate a mobile device (such as Chrome's "Device Toolbar") in both portrait and landscape orientations. The "Rotate My Device" button won't actually function, as mentioned before there is poor desktop support for `window.screen.orientation.lock`, but you should be able to see the different UIs if you manually rotate the orientation using the developer tooling.

Before we jump into implementing the iOS and Android platforms for our `ScreenOrientation` plugin, we'll take a detour to discuss the different types of [code abstraction](/docs/code-abstractions.md) that make sense to use when building out Capacitor plugins.
