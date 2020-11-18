package io.ionic.starter.AppVersion;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

import android.content.pm.PackageInfo;

@NativePlugin()
public class AppVersion extends Plugin{

    @PluginMethod()
    public void getAppVersion(PluginCall call) {
        JSObject result = new JSObject();
        try {
            PackageInfo packageInfo = getContext().getPackageManager().getPackageInfo(getContext().getPackageName(), 0);
            result.put("value", packageInfo.versionName);
            call.success(result);
        } catch (Exception ex) {
            result.put("value", "");
            call.success(result);
        }
    }
}
