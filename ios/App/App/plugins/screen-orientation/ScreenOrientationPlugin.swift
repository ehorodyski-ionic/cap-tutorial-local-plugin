//  ScreenOrientationPlugin.swift

import Capacitor

@objc(ScreenOrientationPlugin)
public class ScreenOrientationPlugin: CAPPlugin {
  
  private let implementation = ScreenOrientation()
  
  @objc public func orientation(_ call: CAPPluginCall) {
    let currentOrientation = implementation.getCurrentOrientation()
    call.resolve(currentOrientation)
  }
  
  @objc public func lock(_ call: CAPPluginCall) {
    call.resolve()
  }
  
  @objc public func unlock(_ call: CAPPluginCall) {
    call.resolve()
  }
  
}
