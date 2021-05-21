package io.ionic.cs.capLocalPlugin.plugins.ScreenOrientation;

import com.getcapacitor.JSObject;

import android.content.pm.ActivityInfo;
import android.view.Surface;

public class ScreenOrientation {

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

}
