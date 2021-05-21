# Android Implementation

Last but not least we will implement the `ScreenOrientation` plugin for Android. As we did for the web and iOS we will adhere to the plugin API defined in the [Designing the Plugin API](/docs/designing-api.md) step.

## Android API Documentation

I generally find the [Android Developers Documentation](https://developer.android.com/docs) to be more of a user friendly API reference portal compared to Apple. For instance if I search "change screen orientation" in the nav bar, the first search result I get back is "Handle configuration changes" which has a code sample on how to handle when the [screen orientation changes](https://developer.android.com/guide/topics/resources/runtime-changes).

While more developer friendly than iOS, the Android Developers Documentation can be confusing to find the _exact_ piece of information you're looking for. In our case, that would be locking and unlocking the screen orientation. When the Android Developers Documentation fails me, I head over to StackOverflow, GitHub, and even just do a Google search to find examples of what I'm looking to achieve. As long as you maintain a mindset that you'll need to fit the code into Capacitor's plugin structure, you'll be golden!

For the Android implementation, I followed the examples provided by the following links:

- Stack Overflow: [Orientation Lock in Android Programmatically](https://stackoverflow.com/questions/20209511/orientation-lock-in-android-programmatically)
- Stack Overflow: [Check Orientation on Android Phone](https://stackoverflow.com/questions/2795833/check-orientation-on-android-phone)

## Registering with Capacitor

> **Note:** It's recommended to familiarize yourself with the [Capacitor - Custom Native Android Code documentation](https://capacitorjs.com/docs/android/custom-code) before continuing.

The optimal way to write the Android implementation of a Capacitor plugin is from within Android Studio. Open up the Capacitor application in Android Studio by running the following command:

```bash
$ npx cap open android
```

Once the project completes loading, take a look at the left panel and expand the bolded **app** node and the **java** node. You will see a node named **io.ionic.cs.capLocalPlugin**. This is where the source code for our Capacitor app lives for an Android project and where we are going to add our plugin code.

For this tutorial, we are going to create a new package to house our plugin code:

```
io.ionic.cs.capLocalPlugin.plugins.ScreenOrientation
```

This is a good package structure to follow:

1. It isolates local plugin code in a package outside of the rest of the application's generated source code.
2. It isolates each plugin's code within it's own package in the event more plugins are to be added in the future.

To create these packages right-click on the `io.ionic.cs.capLocalPlugin` node and select **New > Folder > Package** and name it `io.ionic.cs.capLocalPlugin.plugins.ScreenOrientation`.

Right-click the `plugins.ScreenOrientation` node and select **New > Java Class** and name it `ScreenOrientationPlugin`. Populate the file such that it matches the API we defined:

```Java
// ScreenOrientationPlugin.java

package io.ionic.cs.capLocalPlugin.plugins.ScreenOrientation;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

@NativePlugin
public class ScreenOrientationPlugin extends Plugin {

    @PluginMethod
    public void orientation(PluginCall call) {
        call.success();
    }

    @PluginMethod
    public void lock(PluginCall call) {
        call.success();
    }

    @PluginMethod
    public void unlock(PluginCall call) {
        call.success();
    }
}
```

### Updating MainActivity

Next, open up `MainActivity.java` from the `io.ionic.cs.capLocalPlugin` node. Update the `onCreate()` method like so:

```Java
@Override
public void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);

  // Initializes the Bridge
  this.init(savedInstanceState, new ArrayList<Class<? extends Plugin>>() {{
    // Additional plugins you've installed go here
    add(ScreenOrientationPlugin.class);
  }});
}
```

The `add()` method registers your plugin with Capacitor, making `ScreenOrientationPlugin` and it's methods available to JavaScript. Unlike iOS, you do not need to modify this statement whenever methods are added or removed from the plugin.

## Implementing the API

Begin by creating a new Java class in the `plugins.ScreenOrientation` node named `ScreenOrientation`. This will be out implementation file, where the bulk of the work will be performed.

Start by adding a few imports to the class file:

```Java
package io.ionic.cs.capLocalPlugin.plugins.ScreenOrientation;

import com.getcapacitor.JSObject;

import android.content.pm.ActivityInfo;
import android.view.Surface;

public class ScreenOrientation {

}
```

Generally speaking, Android Studio will prompt you to auto-add any imports required as you develop. For the sake of this tutorial I've pre-supplied them for us. After we implement some code I advise you revisit this section and search the APIs for the modules we've imported.

Head back to `ScreenOrientationPlugin.java` and add the following code:

```Java
...snip...
@NativePlugin
public class ScreenOrientationPlugin extends Plugin {

  private ScreenOrientation implementation = new ScreenOrientation();

  ...snip...

}
```

The basic setup of our thin-binding plugin architecture is in place. The next few sections will focus on implementing a specific method from the plugin's API definition.

### Getting the Current Screen Orientation

Returning the device's current orientation consists of three steps:

1. Obtaining the device's current orientation direction (as an integer) through the `getRotation()` method
2. Map the integer's `Surface` enumeration value to the type of `{type: OrientationType; angle:number}`
3. Returning the mapped value back to Capacitor

Add the following method to the `ScreenOrientation` class in `ScreenOrientation.java`:

```Java
public JSObject getCurrentOrientation(int rotation) {
    JSObject orientationType = new JSObject();
    switch (rotation) {
        case Surface.ROTATION_90:
            orientationType.put("type", "landscape-primary");
            orientationType.put("angle", 90);
        case Surface.ROTATION_180:
            orientationType.put("type", "portrait-secondary");
            orientationType.put("angle", 180);
        case Surface.ROTATION_270:
            orientationType.put("type", "landscape-secondary");
            orientationType.put("angle", -90);
        default:
            orientationType.put("type", "portrait-primary");
            orientationType.put("angle", 0);
    }
    return orientationType;
}
```

Unfortunately, there is no way to obtain the orientation angle through the iOS APIs. That's OK, we can derive what those values should be by playing around with the [Screen Orientation Web API](https://developer.mozilla.org/en-US/docs/Web/API/ScreenOrientation/angle). Which is exactly what I did for you 😊

Next, wire up the `orientation` method in `SwiftOrientationPlugin.swift` to call our implementation:

```Java
@PluginMethod
public void orientation(PluginCall call) {
    int rotation = getBridge()
            .getActivity()
            .getWindowManager()
            .getDefaultDisplay()
            .getRotation();
    JSObject orientation = implementation.getCurrentOrientation(rotation);
    call.success(orientation);
}
```

## Test it out!
