# iOS Implementation

This walkthrough starts with the iOS implementation of the `ScreenOrientation` plugin, but we could have started with Android. I made an arbitrary decision to do so, we could have started with Android and it wouldn't have mattered. However, I strongly urge that when developing a Capacitor plugin the web implementation gets taken care of first before moving into native code. The web implementation sits closer to the plugin's API definition, so if any tweaks need to be made to the API it's easier to uncover them while working in the TypeScript layer.

## iOS API Documentation

I did a quick Google search for "device orientation ios api" and the first result brought back goes to [UIDeviceOrientation | Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uideviceorientation). The documentation tells us that `UIDeviceOrientation` is an enumeration and gives us some information on what else it contains. It's a standard API reference document.

It's not very helpful in our case; we're sort of looking for how to do things like get the current device orientation and how to programmatically set it. Your mileage may vary, but in the cases where I write native iOS code I rely on places like StackOverflow, GitHub, and Apple's Developer Forums for examples of how to _use_ the APIs.

For the iOS implementation, I followed the examples provided by the following links:

- Stack Overflow: [Getting Device Orientation in Swift](https://stackoverflow.com/a/25796597)
- Apple Developer Forums: [How to lock screen orientation for a specific view?](https://developer.apple.com/forums/thread/128830)

These examples are great, so let's reference them as we build out the iOS implementation of the plugin!

## Registering with Capacitor

> **Note:** It's recommended to familiarize yourself with the [Capacitor - Custom Native iOS Code documentation](https://capacitorjs.com/docs/ios/custom-code) before continuing.

The optimal way to write the iOS implementation of a Capacitor plugin is from within Xcode. Open up the Capacitor application in Xcode by running the following command:

```bash
$ npx cap open ios
```

Once you are in, take a look at the left panel of the Xcode project and expand the **App** icon in the pane. Open the nested **App** folder inside of it. This is where the source code for our Capacitor app lives for an iOS project and where we are going to add our plugin code.

For this tutorial, we are going to put all of our plugin code in the folder path:

```
/App/App/plugins/screen-orientation
```

This is a good folder structure to follow:

1. It isolates local plugin code in a folder outside of the rest of the application's generated source code.
2. It isolates each plugin's code within it's own folder in the event more plugins are to be added in the future.

To create this folder structure, right-click the nested **App** folder and select **New Group** and name this folder `plugins`. Right-click on the new `plugins` folder and do the same to create the `screen-orientation` folder.

Click the `screen-orienation` folder and in the menu bar click **File > New > File...** Select **Swift File** and name it `ScreenOrientationPlugin.swift`. Populate the file such that it matches the API we defined:

```Swift
//  ScreenOrientationPlugin.swift

import Capacitor

@objc(ScreenOrientationPlugin)
public class ScreenOrientationPlugin: CAPPlugin {

  @objc func orientation(_ call: CAPPluginCall) {
    call.resolve()
  }

  @objc func lock(_ call: CAPPluginCall) {
    call.resolve()
  }

  @objc func unlock(_ call: CAPPluginCall) {
    call.resolve()
  }

}
```

Note the use of `@objc` decorators. These decorators are required to make sure that Capacitor's runtime can see the class and it's methods.

### Objective-C Macro

Next, create a `ScreenOrientationPlugin.m` file in Xcode the same way (and same folder) as was done for the Swift file. This time, choose **Objective-C** as the file type. When prompted by Xcode to create a Bridging Header, click **Create Bridging Header**.

Add the following code into `ScreenOrientationPlugin.m`:

```objc
//  ScreenOrientationPlugin.m

#import <Capacitor/Capacitor.h>

CAP_PLUGIN(ScreenOrientationPlugin, "ScreenOrientation",
  CAP_PLUGIN_METHOD(orientation, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(lock, CAPPluginReturnPromise);
  CAP_PLUGIN_METHOD(unlock, CAPPluginReturnPromise);
)
```

These Objective-C macros register your plugin with Capacitor, making `ScreenOrientationPlugin` and it's methods available to JavaScript. Whenever you add or remove methods that should be exposed to the web portion of your Capacitor project, you must update these macros as well.

## Implementing the API

Begin by creating a new Swift file in the `screen-orientation` folder named `ScreenOrientation.swift`. This will be our implementation file, where the bulk of the work will be performed.

Start by creating a new class for this file: `ScreenOrientation`. Add the following code to `ScreenOrientation.swift`:

```Swift
//  ScreenOrientation.swift

import Foundation
import UIKit

@objc public class ScreenOrientation: NSObject {

}
```

Nothing too complex yet, just the creation of a Swift class with an `@objc` decorator and an import of the `UIKit` library which is needed to access `UIDeviceOrientation`. On the plugin side, we'll want to create an instance of the `ScreenOrientation` class as a private member. Add the following code to `ScreenOrientationPlugin.swift`:

```Swift
... snip ...
@objc(ScreenOrientationPlugin)
public class ScreenOrientationPlugin: CAPPlugin {

  private let implementation = ScreenOrientation()

  ... snip ...
}
```

With the basic setup of thin-binding in place, the next few sections will focus on implementing a specific method from the plugin's API definition.

### Getting the Current Orientation
