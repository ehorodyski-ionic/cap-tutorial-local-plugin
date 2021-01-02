//
//  ScreenOrientation.swift
//  App
//
//  Created by Eric Horodyski on 11/25/20.
//

import Capacitor

@objc(ScreenOrientation)
public class ScreenOrientation: CAPPlugin {
  
  @objc func orientation(_ call: CAPPluginCall) {
    let current: UIDeviceOrientation = UIDevice.current.orientation
    let orientationType = OrientationUtilities.fromEnumToOrientationType(current)
    call.success(orientationType)
  }
    
  @objc func lock(_ call: CAPPluginCall) {
    guard let orientation = call.getString("orientation") else {
      call.reject("Orientation must be provided.")
      return
    }
    
    DispatchQueue.main.async {
      let deviceOrientation = OrientationUtilities.fromOrientationTypeToEnum(orientation)
      let orientationMask = OrientationUtilities.fromEnumToMask(deviceOrientation)
      let lock = ["orientation": orientationMask]

      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OrientationLock"), object: self, userInfo: lock )
      UIDevice.current.setValue(deviceOrientation.rawValue, forKey: "orientation")
      UINavigationController.attemptRotationToDeviceOrientation()
      
      call.success()
    }
  }
    
    @objc func unlock(_ call: CAPPluginCall) {
      DispatchQueue.main.async {
        let unlock = ["orientation": UIInterfaceOrientationMask.all]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OrientationLock"), object: self, userInfo: unlock)
        UINavigationController.attemptRotationToDeviceOrientation()
        
        call.success()
      }
    }
}
