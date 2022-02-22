//
//  UIAlertController+MavlExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2020/10/30.
//
import UIKit
import Foundation

extension UIAlertController {
    
    /// 在指定视图控制器上弹出提示框 -- 只有title和一个按钮
    public static func xnShowAlertTitleWithActionTitle(title: String?, viewController: UIViewController, actionTitle: String?) {
        self.xnShowAlertWithAction(title: title, viewController: viewController, okActionTitle: actionTitle)
    }
    
    /// 在指定视图控制器上弹出提示框 -- 只有title和两个按钮
    public static func xnShowAlertTitleWithActionsTitle(title: String?, viewController: UIViewController, actionTitle: String?, cancelTitle: String?) {
        self.xnShowAlertWithAction(title: title, viewController: viewController, okActionTitle: actionTitle, cancelActionTitle: cancelTitle)
    }
    
    /// 在指定视图控制器上弹出提示框不带事件 -- title、message和两个按钮
    public static func xnShowAlert(title: String? = nil, message: String? = nil, viewController: UIViewController, actionTitle: String? = "", cancelTitle: String? = nil) {
        self.xnShowAlertWithAction(title: title, message: message, viewController: viewController, okActionTitle: actionTitle, cancelActionTitle: cancelTitle)
    }
    
    /// 在指定视图控制器上弹出提示框 多个按钮的弹框 带点击事件
    /// - Parameters:
    ///   - title: 弹框主标题
    ///   - message: 弹框描述信息
    ///   - viewController: 弹出弹框的VC控制器
    ///   - okActionTitle: 确定按钮标题
    ///   - cancelActionTitle: 取消按钮标题
    ///   - okActionClick: 确定按钮点击事件
    ///   - cancelActionClick: 取消按钮点击事件
    ///   - okOnLeft: 确定按钮是否在左边显示
    public static func xnShowAlertWithAction(title: String? = nil, message: String? = nil, viewController: UIViewController, okActionTitle: String? = "", cancelActionTitle: String? = nil, okActionClick:((UIAlertAction)->Void)? = nil,cancelActionClick: ((UIAlertAction)->Void)? = nil, okOnLeft: Bool? = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if okOnLeft == true {
            if let okActionTitle = okActionTitle {
                alert.addAction(UIAlertAction(title: okActionTitle, style: .default, handler: okActionClick))
            }
            if let cancelActionTitle = cancelActionTitle {
                alert.addAction(UIAlertAction(title: cancelActionTitle, style: .default, handler: cancelActionClick))
            }
        } else {
            if let cancelActionTitle = cancelActionTitle {
                alert.addAction(UIAlertAction(title: cancelActionTitle, style: .default, handler: cancelActionClick))
            }
            if let okActionTitle = okActionTitle {
                alert.addAction(UIAlertAction(title: okActionTitle, style: .default, handler: okActionClick))
            }
        }
        viewController.present(alert, animated: true)
    }
    
    
    /// 在指定视图控制器上弹出sheet提示框 -- 标题可选 action必填
    public static func xnShowSheetAlert(title: String? = nil, message: String? = nil, viewController: UIViewController, actions: [String], cancelStr: String? = nil) {
        let alertSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for action in actions {
            alertSheet.addAction(UIAlertAction(title: action, style: .default))
        }
        if let cancelStr = cancelStr {
            alertSheet.addAction(UIAlertAction(title: cancelStr, style: .cancel))
        }
        viewController.present(alertSheet, animated: true)
    }
    
}
