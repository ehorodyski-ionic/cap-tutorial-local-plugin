//  ScreenOrientationPlugin.swift

import Capacitor
import UIKit

@objc(ScreenOrientationPlugin)
public class ScreenOrientationPlugin: CAPPlugin {
  
  private let implementation = ScreenOrientation()
  
  public static var supportedOrientations = UIInterfaceOrientationMask.all
  
  @objc public func orientation(_ call: CAPPluginCall) {
    let currentOrientation = implementation.getCurrentOrientation()
    call.resolve(currentOrientation)
  }
  
  @objc public func lock(_ call: CAPPluginCall) {
    guard let lockedOrientation = call.getString("orientation") else {
      call.reject("Input option 'orientation' must be provided.")
      return
    }
    
    DispatchQueue.main.async {
      ScreenOrientationPlugin.supportedOrientations = UIInterfaceOrientationMask.landscapeRight
      UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
      UINavigationController.attemptRotationToDeviceOrientation()
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
