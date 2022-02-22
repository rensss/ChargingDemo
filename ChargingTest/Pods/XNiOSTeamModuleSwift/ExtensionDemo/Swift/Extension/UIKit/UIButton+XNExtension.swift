//
//  UIButton+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2021/4/7.
//

import UIKit

public typealias xnButtonClickClosure = (UIButton) -> ()

extension UIButton {
    
    private struct AssociatedKey {
        static var clickCallbackKey: String = "clickCallbackKey"
    }
    
    private var clickCallback: xnButtonClickClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.clickCallbackKey) as? xnButtonClickClosure
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.clickCallbackKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    @objc func clickButton(btn: UIButton) {
        self.clickCallback?(btn)
    }
    
    /// 设置按钮点击事件的闭包 (注意循环引用 [unowned/weak])
    /// - Parameter handler: 闭包回调
    public func xnClickCallback(_ handler: @escaping xnButtonClickClosure) {
        self.clickCallback = handler
        self.addTarget(self, action: #selector(clickButton(btn:)), for: .touchUpInside)
    }
}
