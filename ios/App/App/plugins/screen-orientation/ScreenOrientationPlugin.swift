//  ScreenOrientationPlugin.swift

import Capacitor
import UIKit

@objc(ScreenOrientationPlugin)
public class ScreenOrientationPlugin: CAPPlugin, UIApplicationDelegate {
  
  private let implementation = ScreenOrientation()
  
    
  @objc public func orientation(_ call: CAPPluginCall) {
    let currentOrientation = implementation.getCurrentOrientation()
    call.resolve(currentOrientation)
  }
  
  @objc public func lock(_ call: CAPPluginCall) {
    guard let lockedOrientation = call.getString("orientation") else {
      call.reject("Orientation must be provided.")
      return
    }
    
    DispatchQueue.main.async {
      
     /* let lock = ["orientation": UIInterfaceOrientation.landscapeRight.rawValue]
 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CAPOrientationLock"), object: self, userInfo: lock)
      UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
      UINavigationController.attemptRotationToDeviceOrientation() */
 
      
      
      call.resolve()
    }
    
    
    
  }
  
  @objc public func unlock(_ call: CAPPluginCall) {
    DispatchQueue.main.async {
      let unlock = ["orientation": UIInterfaceOrientationMask.all]
      
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OrientationLock"), object: self, userInfo: unlock)
      UINavigationController.attemptRotationToDeviceOrientation()
      
      call.resolve()
  }
  }
  
}
