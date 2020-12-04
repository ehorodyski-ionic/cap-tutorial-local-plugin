# Using the Plugin API

Before we work on implementing the `ScreenOrientation` plugin for each platform, let's build out the user interface to our e-signature requirement. This UI will make calls to our plugin so we can easily test as we build out implementations for each platform.

## User Interface

Since the focus of this walkthrough is building a Capacitor plugin, not building an Ionic Framework application, let's take the finished versions of `src/pages/Home.tsx` and `src/pages/Home.css` and copy and paste their contents into your project:

- [src/pages/Home.tsx](/src/pages/Home.tsx)
- [src/pages/Home.css](/src/pages/Home.css)

Once you've finished, serve the Capacitor application: `ionic serve`. Open up your browser's developer tools and you should see the following error:

```
Uncaught (in promise) ScreenOrientation does not have web implementation.
```

Makes sense, we haven't implemented any of our API yet! Keep this browser open, we'll be implementing the web platform first. Before we do so, let's review some relevant code from `Home.tsx` in the next section.

## Calling the `ScreenOrientation` Plugin

The `currentOrientation` variable holds the value of the app's current orientation. When the user changes orientation we will programmatically update this variable. This variable also determines which portion of the user interface to display:

```JSX
{orientation.includes('portrait') && (
  {/* Provide a button that will rotate and lock the screen orientation to landscape mode. */}
)}
{orientation.includes('landscape') && (
  {/* Let the user "sign" and unlock screen orientation through a confirmation button. */}
)}
```

The screen orientation is retrieved and stored as part of the page's state through the `getOrientation` function:

```TypeScript
const getOrientation = async () => {
  const { ScreenOrientation } = Plugins;
  const { type } = await ScreenOrientation.orientation();
  setCurrentOrientation(type);
};
```

`getOrientation` gets called during page initialization:

```TypeScript
useEffect(() => { (async () => {
  await getOrientation();
})(); }, []);
```

...and when the `orientationchange` event is fired:

```TypeScript
window.addEventListener('orientationchange', async () => await getOrientation());
```

A button is provided when the orientation is in portrait mode that will rotate and lock the screen orientation in landscape mode:

```TypeScript
// onClick={() => lockOrientation()}
const lockOrientation = async () => {
  const { ScreenOrientation } = Plugins;
  await ScreenOrientation.lock({ orientation: 'landscape-primary' });
};
```

Likewise, a button is provided when the orientation is in landscape mode that will release the orientation lock:

```TypeScript
// onClick={() => unlockOrientation()}
const unlockOrientation = async () => {
  const { ScreenOrientation } = Plugins;
  await ScreenOrientation.unlock();
};
```

The rest of the code in `Home.tsx` and `Home.css` is purely cosmetic; we don't need to dig deep into that.

With this complete, we can move onto the [first platform implementation: the web](/docs/web-implementation.md).
