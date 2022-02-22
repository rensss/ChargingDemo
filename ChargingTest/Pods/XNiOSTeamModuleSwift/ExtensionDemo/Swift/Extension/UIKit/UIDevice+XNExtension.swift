//
//  UIDevice+XNExtension.swift
//  ExtensionTestSwift
//
//  Created by xnhl_iosQ on 2021/7/21.
//

import UIKit

extension UIDevice {
    /// 获取System Infos
    var xnDeviceName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,6":                              return "iPhone XS Max"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9"
            case "i386", "x86_64":                          return "Simulator"
            default:                                        return identifier
        }
    }
    
    /// 获取系统版本
    public static func xnGetSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    /// 获取电池水平 （ 其中返回值为 -1 代表模拟器或者电池不可用 ）
    public static func xnGetBatteryLevel() -> Float {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        return device.batteryLevel
    }
    
    /*  获取电池状态
        Unknown：无法取得充电状态情况
        Unplugged：非充电状态
        Charging：充电状态
        Full：充满状态（连接充电器充满状态）
    */
    public static func xnGetBatteryStatus() -> String {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        let array = ["Unknown", "Unplugged", "Charging", "Full"]
        return array[device.batteryState.rawValue]
    }
    
}
