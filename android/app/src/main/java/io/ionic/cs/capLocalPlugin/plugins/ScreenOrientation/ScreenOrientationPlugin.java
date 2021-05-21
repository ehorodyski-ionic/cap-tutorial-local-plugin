package io.ionic.cs.capLocalPlugin.plugins.ScreenOrientation;

import android.content.pm.ActivityInfo;

import com.getcapacitor.JSObject;
import com.getcapacitor.Logger;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

@NativePlugin(name="ScreenOrientation")
public class ScreenOrientationPlugin extends Plugin {

    private ScreenOrientation implementation = new ScreenOrientation();

    @PluginMethod
    public void orientation(PluginCall call) {
        int rotation = getBridge()
                .getActivity()
                .getWindowManager()
                .getDefaultDisplay()
                .getRotation();
        JSObject orientation = implementation.getCurrentOrientation(rotation);
        call.resolve(orientation);
    }

    @PluginMethod
    public void lock(PluginCall call) {
        String orientation = call.getString("orientation");
        if (orientation == null) {
            call.reject("Input option 'orientation' must be provided.");
            return;
        }
        int orientationEnum = implementation.getOrientationEnumValue(orientation);
        getBridge().getActivity().setRequestedOrientation(orientationEnum);
        call.resolve();
    }

    @PluginMethod
    public void unlock(PluginCall call) {
        getBridge().getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
        call.resolve();
    }
}
