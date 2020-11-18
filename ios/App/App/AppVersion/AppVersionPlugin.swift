//
//  AppVersionPlugin.swift
//  App
//
//  Created by Eric Horodyski on 11/18/20.
//

import Foundation
import Capacitor

@objc(IONAppVersionPlugin)
public class IONAppVersionPlugin: CAPPlugin {
    
    @objc func getAppVersion(_ call: CAPPluginCall) {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        call.success(["value": appVersion])
    }
    
}
