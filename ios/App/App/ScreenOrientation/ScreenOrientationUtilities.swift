//
//  DeviceOrientationManager.swift
//  App
//
//  Created by Eric Horodyski on 11/25/20.
//

import Foundation
import UIKit

public class ScreenOrientationUtilities {
  
  static func fromEnumToOrientationType(_ orientation: UIDeviceOrientation) -> Dictionary<String, Any> {
    switch orientation {
    case .portraitUpsideDown:
      return ["type": "portrait-secondary", "angle": 180]
    case .landscapeLeft:
      return ["type": "landscape-primary", "angle": 90]
    case .landscapeRight:
      return ["type": "landscape-secondary", "angle": -90]
    default:
      return ["type": "portrait-primary", "angle":  0]
    }
  }
    
  static func fromOrientationTypeToEnum(_ orientation: String) -> UIDeviceOrientation {
    switch orientation {
    case "portrait-primary":
      return UIDeviceOrientation.portrait
    case "portrait-secondary":
      return UIDeviceOrientation.portraitUpsideDown
    case "landscape-primary":
      return UIDeviceOrientation.landscapeRight
    case "landscape-secondary":
      return UIDeviceOrientation.landscapeLeft
    default:
      return UIDeviceOrientation.unknown
    }
  }
  
  static func fromEnumToMask(_ orientation: UIDeviceOrientation) -> UIInterfaceOrientationMask {
    switch orientation {
    case .portrait:
      return UIInterfaceOrientationMask.portrait
    case .portraitUpsideDown:
      return UIInterfaceOrientationMask.portraitUpsideDown
    case .landscapeLeft:
      return UIInterfaceOrientationMask.landscapeLeft
    case .landscapeRight:
      return UIInterfaceOrientationMask.landscapeRight
    default:
      return UIInterfaceOrientationMask.all
    }
  }
    
}
