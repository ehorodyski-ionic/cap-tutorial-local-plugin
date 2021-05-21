package io.ionic.cs.capLocalPlugin.plugins.ScreenOrientation;

import com.getcapacitor.JSObject;
import com.getcapacitor.Logger;

import android.content.pm.ActivityInfo;
import android.view.Surface;

public class ScreenOrientation {

    public JSObject getCurrentOrientation(int rotation) {
        JSObject orientationType = new JSObject();
        switch (rotation) {
            case Surface.ROTATION_90:
                orientationType.put("angle", 90);
                orientationType.put("type", "landscape-primary");
                return orientationType;
            case Surface.ROTATION_180:
                orientationType.put("angle", 180);
                orientationType.put("type", "portrait-secondary");
                return orientationType;
            case Surface.ROTATION_270:
                orientationType.put("angle", -90);
                orientationType.put("type", "landscape-secondary");
                return orientationType;
            default:
                orientationType.put("angle", 0);
                orientationType.put("type", "portrait-primary");
                return orientationType;
        }
    }

    public int getOrientationEnumValue(String orientation) {
        switch (orientation) {
            case "portrait-primary":
                return ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
            case "portrait-secondary":
                return ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT;
            case "landscape-primary":
                return ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE;
            case "landscape-secondary":
                return ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE;
            default:
                return ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED;
        }
    }

}
