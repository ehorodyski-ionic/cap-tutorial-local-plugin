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
  
    let orientationEnums = implementation.getOrientationEnumValues(lockedOrientation)
    ScreenOrientationPlugin.supportedOrientations = orientationEnums["mask"] as! UIInterfaceOrientationMask
    
    DispatchQueue.main.async {
      UIDevice.current.setValue((orientationEnums["device"] as! UIDeviceOrientation).rawValue, forKey: "orientation")
      UINavigationController.attemptRotationToDeviceOrientation()
      call.resolve()
    }
  }
  
  @objc public func unlock(_ call: CAPPluginCall) {
    ScreenOrientationPlugin.supportedOrientations = UIInterfaceOrientationMask.all
    
    DispatchQueue.main.async {
      UINavigationController.attemptRotationToDeviceOrientation()
      call.resolve()
    }
  }
  
}
