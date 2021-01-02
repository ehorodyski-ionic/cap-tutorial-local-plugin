//  ScreenOrientationPlugin.swift

import Capacitor

@objc(ScreenOrientationPlugin)
public class ScreenOrientationPlugin: CAPPlugin {
  
  @objc func orientation(_ call: CAPPluginCall) {
    call.success()
  }
  
  @objc func lock(_ call: CAPPluginCall) {
    call.success()
  }
  
  @objc func unlock(_ call: CAPPluginCall) {
    call.success()
  }
  
}
