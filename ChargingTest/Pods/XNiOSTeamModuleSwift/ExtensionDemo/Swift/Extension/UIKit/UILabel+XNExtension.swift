//
//  UILabel+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2020/12/10.
//

import UIKit

extension UILabel {
    
    /// 添加删除线
   public static func xnAddDeleteLineWithColor(label: UILabel, color: UIColor) {
        let view = UIView.init(frame: CGRect(x: 0, y: label.xnHeight/2, width: label.xnWidth, height: 1))
        view.backgroundColor = color
        label.addSubview(view)
    }
    
}
