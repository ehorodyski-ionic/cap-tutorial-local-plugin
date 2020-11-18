//
//  AppVersionPlugin.m
//  App
//
//  Created by Eric Horodyski on 11/18/20.
//

#import <Capacitor/Capacitor.h>

CAP_PLUGIN(IONAppVersionPlugin, "AppVersion",
    CAP_PLUGIN_METHOD(getAppVersion, CAPPluginReturnPromise);
)
