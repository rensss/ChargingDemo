//
//  UIWindow+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2020/10/30.
//

import UIKit
import Foundation

extension UIWindow {
    
    /// 获取keywindow
    public static func xnKeyWindow() -> UIWindow? {
        let keyWindow: UIWindow?
        if #available(iOS 13.0, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        } else {
            keyWindow = UIApplication.shared.keyWindow
        }
        return keyWindow
    }
    
    /// 获取当前显示的VC
    public static func xnGetCurrentViewController() -> UIViewController? {
        guard var keyWindow = xnKeyWindow() else { return nil }
        if keyWindow.windowLevel != .normal {
            let windowArr = UIApplication.shared.windows
            for window in windowArr {
                if window.windowLevel == UIWindow.Level.normal {
                    keyWindow = window
                    break
                }
            }
        }
        return xnGetNextXController(nextController:keyWindow.rootViewController)
    }
    
    public static func xnGetNextXController(nextController: UIViewController?) -> UIViewController? {
        if nextController == nil {
            return nil
        } else if nextController?.presentedViewController != nil {
            return UIWindow.xnGetNextXController(nextController: nextController?.presentedViewController)
        } else if let tabbar = nextController as? UITabBarController {
            return UIWindow.xnGetNextXController(nextController: tabbar.selectedViewController)
        } else if let nav = nextController as? UINavigationController {
            return UIWindow.xnGetNextXController(nextController: nav.visibleViewController)
        }
        return nextController
    }

}
