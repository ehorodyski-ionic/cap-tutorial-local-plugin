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
...snip...
@objc(ScreenOrientationPlugin)
public class ScreenOrientationPlugin: CAPPlugin {

  private let implementation = ScreenOrientation()

  ...snip...
}
```

With the basic setup of thin-binding in place, the next few sections will focus on implementing a specific method from the plugin's API definition.

### Getting the Current Orientation

Returning the device's current orientation consists of three steps:

1. Obtaining the device's current orientation direction through the `UIDevice` object
2. Mapping the current `UIDeviceOrientation` enumeration value to the a type of `{type: OrientationType; angle: number}`
3. Returning the mapped value back to Capacitor

Add the following method to the `ScreenOrientation` class in `ScreenOrientation.swift`:

```Swift
public func getCurrentOrientation() -> Dictionary<String, Any> {
  let deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation

  switch deviceOrientation {
  case .landscapeRight:
    return ["type": "landscape-secondary", "angle": -90]
  case .landscapeLeft:
    return ["type": "landscape-primary", "angle": 90]
  case .portraitUpsideDown:
    return ["type": "portrait-secondary", "angle": 180]
  default:
    // Case: .portrait
    return ["type": "portrait-primary", "angle":  0]
  }
}
```

Unfortuantely, there is no way to obtain the orientation angle through the iOS APIs. That's OK, we can derive what those values should be by playing around with the [Screen Orientation Web API](https://developer.mozilla.org/en-US/docs/Web/API/ScreenOrientation/angle). Which is exactly what I did for you 😊

Next, wire up the `orientation` method in `SwiftOrientationPlugin.swift` to call our implementation:

```Swift
...snip...

  @objc public func orientation(_ call: CAPPluginCall) {
    let currentOrientation = implementation.getCurrentOrientation()
    call.resolve(currentOrientation)
  }

...snip...
```

Nice and concise...I love it! You've made it this far without running your application. That was intentional on my part as the plugin would break the app since we weren't returning anything for this method up until this point. Now that we have the first plugin the application calls implemented go ahead and run the app in Xcode, either through a simulator or a device. Once the app finishes loading, you should see the following logs printed to the **Console Window** in the bottom right portion of the main Xcode pane:

```bash
⚡️  To Native ->  ScreenOrientation orientation 111583311
⚡️  TO JS {"angle":0,"type":"portrait-primary"}
```

We've successfully bridged native iOS code into Capacitor's JavaScript layer! The exact values of the logs will be different for you. For example `111583311` is just an arbitrary ID given to the plugin's method call instance, and should the device/simulator not be in orientated where the notch is on top the values in the second line will correspond with the logic we implemented. Regardless, the focus here is that our iOS implementation of `ScreenOrientation.orientation` is working! 🎉

### Locking an Orientation

In order to lock the screen orientation of an iOS application a special `application` method must be added to `AppDelegate.swift`:

```Swift
func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
```

This method is used to programmatically tell the application which orientations are allowed for the application. Phrased differently, iOS allows you to programmatically place restrictions on which orientations the application supports.

Let's go ahead and implement this method, creating a class-level variable that will hold the supported orientations mask value. Below the declaration of the `window` variable in `AppDelegate.swift` add the following code:

```Swift
...snip...
var supportedOrientations = UIInterfaceOrientationMask.all

func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
  return supportedOrientations
}
...snip...
```

The code above lets iOS know that our application supports the `UIInterfaceOrientationMask` according to the value held in `supportedOrientations` (which is defaulted to all orientations). If the value of `supportedOrientations` is changed, the application will respect the restriction put in place. So, when we call `ScreenOrientation.lock()` and `ScreenOrientation.unlock()` what we need to do is update the value of `supportedOrientations`.

The next piece of the puzzle becomes how do we communicate from our plugin to the `AppDelegate`?

#### Adding an Observer to `NotificationCenter`
