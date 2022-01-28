//
//  MBProgressHUD+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2020/12/9.
//

import UIKit
import MBProgressHUD

extension MBProgressHUD {
    
    public static func xnShowIndicator() {
        MBProgressHUD.xnShowIndicatorWithHideAfterYOffset(nil)
    }
    
    public static func xnShowIndicatorMessage(_ message: String?) {
        MBProgressHUD.xnShowIndicatorWithHideAfterYOffset(message)
    }
    
    public static func xnShowIndicatorWithHideAfter(_ message: String?, timeInterval: TimeInterval? = nil) {
        MBProgressHUD.xnShowIndicatorWithHideAfterYOffset(message, timeInterval: timeInterval)
    }
    
    public static func xnShowIndicatorWithHideAfterYOffset(_ message: String? = nil, timeInterval: TimeInterval? = nil, yOffset: CGFloat = 0.0, showView: UIView? = UIWindow.xnKeyWindow()) {
        xnHideHUD(showView)
        DispatchQueue.main.async(execute: {
            if let view = showView {
                let hud = MBProgressHUD.showAdded(to: view, animated: true)
                hud.mode = .indeterminate
                hud.detailsLabel.text = message
                if let time = timeInterval {
                    hud.hide(animated: true, afterDelay: time)
                }
                var offset = hud.offset
                offset.y = yOffset
                hud.offset = offset
            }
        })
    }
    
    public static func xnShowMessage(_ message: String?) {
        MBProgressHUD.xnShowMessageWithHideAfterYOffset(message)
    }
    
    public static func xnShowMessageWithHideAfter(_ message: String?, timeInterval: TimeInterval) {
        MBProgressHUD.xnShowMessageWithHideAfterYOffset(message, timeInterval: timeInterval)
    }
    
    public static func xnShowMessageWithHideAfterYOffset(_ message: String? = nil, timeInterval: TimeInterval = 1.0, yOffset: CGFloat = 0.0, showView: UIView? = UIWindow.xnKeyWindow()) {
        xnHideHUD(showView)
        DispatchQueue.main.async(execute: {
            if let view = showView {
                let hud = MBProgressHUD.showAdded(to: view, animated: true)
                hud.detailsLabel.text = message
                hud.mode = .text
                hud.detailsLabel.font = .systemFont(ofSize: 14)
                hud.hide(animated: true, afterDelay: timeInterval)
                var offset = hud.offset
                offset.y = yOffset
                hud.offset = offset
            }
        })
    }
    
    public static func xnHideHUD(_ showView: UIView? = UIWindow.xnKeyWindow()) {
        DispatchQueue.main.async(execute: {
            if let view = showView {
                MBProgressHUD.hide(for: view, animated: true)
            }
        })
    }
    
}

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
}
