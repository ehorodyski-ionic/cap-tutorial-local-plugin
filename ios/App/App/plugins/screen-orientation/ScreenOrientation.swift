//  ScreenOrientation.swift

import Foundation
import UIKit

@objc public class ScreenOrientation: NSObject {
  
  public func getCurrentOrientation() -> Dictionary<String, Any> {
    let deviceOrientation: UIDeviceOrientation = UIDevice.current.orientation
    
    switch deviceOrientation {
    case .landscapeRight:
      return ["type": "landscape-secondary", "angle": -90]
    case .landscapeLeft:
      return ["type": "landscape-primary", "angle": 90]
    case .portraitUpsideDown:
      return ["type": "portrait-secondary", "angle": 180]
    default:
      // Case: .portrait
      return ["type": "portrait-primary", "angle":  0]
    }
  }
  
  public func getOrientationEnumValues(_ orientation: String) -> Dictionary<String, Any> {
    switch orientation {
    case "landscape-secondary":
      return [
        "mask": UIInterfaceOrientationMask.landscapeLeft,
        "device": UIDeviceOrientation.landscapeLeft
      ]
    case "landscape-primary":
      return [
        "mask": UIInterfaceOrientationMask.landscapeLeft,
        "device": UIDeviceOrientation.landscapeLeft
      ]
    case "portrait-secondary":
      return [
        "mask": UIInterfaceOrientationMask.portraitUpsideDown,
        "device": UIDeviceOrientation.portraitUpsideDown
      ]
    default:
      // Case "portrait-primary"
      return [
        "mask": UIInterfaceOrientation.portrait,
        "device": UIDeviceOrientation.portrait
      ]
    }
  }
  
}
