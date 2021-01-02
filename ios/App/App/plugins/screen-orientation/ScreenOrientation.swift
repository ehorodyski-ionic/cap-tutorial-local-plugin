//  ScreenOrientation.swift

import Foundation
import UIKit

@objc public class ScreenOrientation: NSObject {
  
  public func getCurrentOrientation() -> Dictionary<String, Any> {
    return ["type": "portrait-primary", "angle":  0]
  }
  
}
