# iOS Implementation

This walk through starts with the iOS implementation of the `ScreenOrientation` plugin, but we could have started with Android. I made an arbitrary decision to do so, we could have started with Android and it wouldn't have mattered. However, I strongly urge that when developing a Capacitor plugin the web implementation gets taken care of first before moving into native code. The web implementation sits closer to the plugin's API definition, so if any tweaks need to be made to the API it's easier to uncover them while working in the TypeScript layer.

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

Click the `screen-orientation` folder and in the menu bar click **File > New > File...** Select **Swift File** and name it `ScreenOrientationPlugin.swift`. Populate the file such that it matches the API we defined:

```Swift
//  ScreenOrientationPlugin.swift

import Capacitor

@objc(ScreenOrientationPlugin)
public class ScreenOrientationPlugin: CAPPlugin {

  @objc public func orientation(_ call: CAPPluginCall) {
    call.resolve()
  }

  @objc public func lock(_ call: CAPPluginCall) {
    call.resolve()
  }

  @objc public func unlock(_ call: CAPPluginCall) {
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

### Getting the Current Screen Orientation

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

Unfortunately, there is no way to obtain the orientation angle through the iOS APIs. That's OK, we can derive what those values should be by playing around with the [Screen Orientation Web API](https://developer.mozilla.org/en-US/docs/Web/API/ScreenOrientation/angle). Which is exactly what I did for you 😊

Next, wire up the `orientation` method in `SwiftOrientationPlugin.swift` to call our implementation:

```Swift
@objc public func orientation(_ call: CAPPluginCall) {
  let currentOrientation = implementation.getCurrentOrientation()
  call.resolve(currentOrientation)
}
```

Nice and concise...I love it! You've made it this far without running your application. That was intentional on my part as the plugin would break the app since we weren't returning anything for this method up until this point. Now that we have the first plugin the application calls implemented go ahead and run the app in Xcode, either through a simulator or a device. Once the app finishes loading, you should see the following logs printed to the **Console Window** in the bottom right portion of the main Xcode pane:

```bash
⚡️  To Native ->  ScreenOrientation orientation 111583311
⚡️  TO JS {"angle":0,"type":"portrait-primary"}
```

We've successfully bridged native iOS code into Capacitor's JavaScript layer! The exact values of the logs will be different for you. For example `111583311` is just an arbitrary ID given to the plugin's method call instance, and should the device/simulator not be in orientated where the notch is on top the values in the second line will correspond with the logic we implemented. Regardless, the focus here is that our iOS implementation of `ScreenOrientation.orientation` is working! 🎉

### Locking the Screen Orientation

iOS provides a special method on the `UIApplicationDelegate` class (of which `AppDelegate` inherits) that allows developers the ability to programmatically set the application's supported orientations:

```Swift
func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
```

If we implement this method in our `AppDelegate.swift` file, we can return a variable that represents the allowed orientations. On lock, we would update the variable to the orientation mask value that matches what is passed in from `ScreenOrientation.lock()` and on unlock update to the orientation mask value that represents all available device orientations.

First, add a static member to `ScreenOrientationPlugin.swift`:

```Swift
...snip...
@objc(ScreenOrientationPlugin)
public class ScreenOrientationPlugin: CAPPlugin {
  private let implementation = ScreenOrientation()

  public static var supportedOrientations = UIInterfaceOrientationMask.all
  ...snip...
}
```

`UIInterfaceOrientationMask.all` is the value that allows all available orientations to be available.

Next, in `AppDelegate.swift` add the following code under `var window: UIWindow?`:

```Swift
func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
  return ScreenOrientationPlugin.supportedOrientations
}
```

With that out of the way, let's implement locking a screen orientation! Our next step is to `guard` against any calls to the `lock` method that do not contain the `orientation` string value we need passed in (as defined by our plugin's API). Within `ScreenOrientationPlugin.swift`, update the `lock` method to match the code below:

```Swift
@objc public func lock(_ call: CAPPluginCall) {
  guard let lockedOrientation = call.getString("orientation") else {
    call.reject("Input option 'orientation' must be provided.")
    return
  }
}
```

It's always good practice to ensure that all required input parameters have been passed, and short-circuit if they haven't. To complete the method, we need to do the following:

1. Map the `orientation` value into it's corresponding `UIInterfaceOrientation` and `UIInterfaceOrientationMask` values.
2. Update the `ScreenOrientationPlugin.supportedOrientations` value.
3. Set the "orientation" key on the iOS `UIDevice` object.
4. Rotate the device to the locked orientation.

Let's write a method inside our `ScreenOrientation` implementation class that will take the input parameter and return a key-value pair of the corresponding iOS enumeration values. Add the following method to `ScreenOrientation.swift`:

```Swift
 public func getOrientationEnumValues(_ orientation: String) -> Dictionary<String, Any> {
    switch orientation {
    case "landscape-secondary":
      return [
        "mask": UIInterfaceOrientationMask.landscapeRight,
        "device": UIDeviceOrientation.landscapeRight
      ]
    case "landscape-primary":
      return [
        "mask": UIInterfaceOrientationMask.landscapeLeft,
        "device": UIDeviceOrientation.landscapeLeft
      ]
    case "portrait-secondary":
      return [
        "mask": UIInterfaceOrientationMask.portraitUpsideDown,
        "device": UIDeviceOrientation.portraitUpsideDown
      ]
    default:
      // Case "portrait-primary"
      return [
        "mask": UIInterfaceOrientation.portrait,
        "device": UIDeviceOrientation.portrait
      ]
    }
  }
```

Now switch over to `ScreenOrientationPlugin.swift` to finish writing the `lock` method:

```Swift
@objc public func lock(_ call: CAPPluginCall) {
  guard let lockedOrientation = call.getString("orientation") else {
    call.reject("Input option 'orientation' must be provided.")
    return
  }

  let orientationEnums = implementation.getOrientationEnumValues(lockedOrientation)
  ScreenOrientationPlugin.supportedOrientations = orientationEnums["mask"] as! UIInterfaceOrientationMask

  DispatchQueue.main.async {
    UIDevice.current.setValue((orientationEnums["device"] as! UIDeviceOrientation).rawValue, forKey: "orientation")
    UINavigationController.attemptRotationToDeviceOrientation()
    call.resolve()
  }
}
```

I won't dig deep into the `DispatchQueue` in this tutorial, just know that it should be used when updating UI in the iOS native layer.

### Unlocking Screen Orientations

Restoring the end user's ability to change screen orientation is quite simple; essentially all we need to do is reverse the steps taken to lock it:

1. Update the `ScreenOrientationPlugin.supportedOrientations` value.
2. Rotate the device to the device's orientation.

The major differences here are that there are no input parameters to guard against, and we don't need to set any values on `UIDevice`.

Go ahead and update the `unlock` method in `ScreenOrientationPlugin.swift`:

```Swift
@objc public func unlock(_ call: CAPPluginCall) {
  ScreenOrientationPlugin.supportedOrientations = UIInterfaceOrientationMask.all

  DispatchQueue.main.async {
    UINavigationController.attemptRotationToDeviceOrientation()
    call.resolve()
  }
}
```

## Test it out!

We covered a lot of ground since I last had you run the app. Let's take a breather and test out the plugin. Run the app (on device or simulator), and pretend you're one of the insurance company's customers looking to add an e-signature. Tap the button to lock the device in landscape mode, turn your device (or rotate the simulator), pretend signing the pad, press the "Add Signature" button and turn/rotate the device/simulator back into portrait mode. Our use case works!

The `ScreenOrientation` plugin is now implemented for web and iOS. Two down, one to go! Naturally, our next step: [the Android implementation](/docs/native-android.md).
