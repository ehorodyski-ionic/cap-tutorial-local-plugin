package io.ionic.cs.capLocalPlugin.plugins.ScreenOrientation;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

@NativePlugin
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
        call.success(orientation);
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
