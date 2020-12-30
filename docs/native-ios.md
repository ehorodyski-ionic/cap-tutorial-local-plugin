# iOS Implementation

This walkthrough starts with the iOS implementation of the `ScreenOrientation` plugin, but we could have started with Android. I made an arbitrary decision to do so, we could have started with Android and it wouldn't have mattered. However, I strongly urge that when developing a Capacitor plugin the web implementation gets taken care of first before moving into native code. The web implementation sits closer to the plugin's API definition, so if any tweaks need to be made to the API it's easier to uncover them while working in the TypeScript layer.

## iOS API Documentation

I did a quick Google search for "device orientation ios api" and the first result brought back goes to [UIDeviceOrientation | Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uideviceorientation). The documentation tells us that `UIDeviceOrientation` is an enumeration and gives us some information on what else it contains. It's a standard API reference document.

It's not very helpful in our case; we're sort of looking for how to do things like get the current device orientation and how to programmatically set it. Your mileage may vary, but in the cases where I write native iOS code I rely on places like StackOverflow, GitHub, and Apple's Developer Forums for examples of how to _use_ the APIs.

For the iOS implementation, I followed the examples provided by the following links:

- Stack Overflow: [Getting Device Orientation in Swift](https://stackoverflow.com/a/25796597)
- Apple Developer Forums: [How to lock screen orientation for a specific view?](https://developer.apple.com/forums/thread/128830)

These examples are great, so let's reference them as we build out the iOS implementation of the plugin!

## Bridging into Capacitor

Open the Capacitor application in Xcode by running the following command:

```bash
$ npx cap open ios
```

Once you're in, look at the left panel of the Xcode project and expand the `App` icon on the left pane. Expand the `App` folder nested within. This is our iOS project, and where we're going to add our plugin code! Right-click the folder and select `New Group`. "New Group" is Xcode's terminology for folders -- it sounds odd to me.

Nevertheless, name the folder `plugins` and then add a "New Group" inside of it called `screen-orientation`. The path should look like this, starting from the top of the tree: `App/App/plugins/screen-orientation`. We are only going to build one plugin in this application, but it's a solid folder structure to follow in the event you want to add more plugins in the future, they are neatly organized and discoverable.

Add a new Swift file insde the `screen-orientation` folder and name it `ScreenOrientationPlugin.swift`. This file will contain all our plugin methods and bindings back to Capacitor. Next, create a new Objective-C file (`.m` extension) named `ScreenOrientationPlugin.m`. Make sure you use the `New File` dialog in Xcode to do this so you get prompted to create a Bridging Header, which you must do.

## Implementing the `ScreenOrientation` API
