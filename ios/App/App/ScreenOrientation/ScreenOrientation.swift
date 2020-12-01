//
//  OrientationPlugin.swift
//  App
//
//  Created by Eric Horodyski on 11/25/20.
//

import Foundation
import Capacitor

@objc(ScreenOrientation)
public class ScreenOrientation: CAPPlugin {
  
  @objc func orientation(_ call: CAPPluginCall) {
    let current: UIDeviceOrientation = UIDevice.current.orientation
    let orientationType = ScreenOrientationUtilities.fromEnumToOrientationType(current)
    call.success(orientationType)
  }
    
  @objc func lock(_ call: CAPPluginCall) {
    guard let orientation = call.getString("orientation") else {
      call.reject("Orientation must be provided.")
      return
    }
    
    DispatchQueue.main.async {
      let deviceOrientation = ScreenOrientationUtilities.fromOrientationTypeToEnum(orientation)
      UIDevice.current.setValue(deviceOrientation.rawValue, forKey: "orientation")
      UINavigationController.attemptRotationToDeviceOrientation()
      call.success()
    }
  }
    
    @objc func unlock(_ call: CAPPluginCall) {
      call.success()
    }
}
