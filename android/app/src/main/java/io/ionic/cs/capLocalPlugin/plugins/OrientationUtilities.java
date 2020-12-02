package io.ionic.cs.capLocalPlugin.plugins;

import com.getcapacitor.JSObject;

import android.content.pm.ActivityInfo;
import android.view.Surface;

public class OrientationUtilities {

    public static JSObject fromAngleToOrientationType(int angle) {
        JSObject orientationType = new JSObject();
        switch (angle) {
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

    public static int fromOrientationTypeToEnum(String orientation) {
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
