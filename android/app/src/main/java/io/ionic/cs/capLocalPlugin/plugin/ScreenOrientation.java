package io.ionic.cs.capLocalPlugin.plugin;

import android.content.pm.ActivityInfo;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

@NativePlugin
public class ScreenOrientation extends Plugin{

    @PluginMethod
    public void orientation(PluginCall call) {
        int angle = getBridge().getActivity().getWindowManager().getDefaultDisplay().getRotation();
        JSObject orientation = OrientationUtilities.fromAngleToOrientationType(angle);
        call.success(orientation);
    }

    @PluginMethod
    public void lock(PluginCall call) {
        String orientation = call.getString("orientation");
        int orientationEnum = OrientationUtilities.fromOrientationTypeToEnum(orientation);
        getBridge().getActivity().setRequestedOrientation(orientationEnum);
        call.success();
    }

    @PluginMethod
    public void unlock(PluginCall call) {
        getBridge().getActivity().setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
        call.success();
    }
}
