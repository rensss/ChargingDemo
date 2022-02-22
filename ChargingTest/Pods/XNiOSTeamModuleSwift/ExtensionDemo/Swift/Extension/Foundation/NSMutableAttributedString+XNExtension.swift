//
//  Url+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2021/5/27.
//

import UIKit

extension NSMutableAttributedString {
    
    /// 设置NSMutableAttributedString行间距
    /// - Parameter spacing: 间距
    /// - Returns: NSMutableAttributedString
    public func xnLineSpacing(_ spacing: CGFloat) -> NSMutableAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = spacing
        addAttribute(NSAttributedString.Key.paragraphStyle, value: paraStyle, range: NSMakeRange(0, string.count))
        return self
    }
    
    /// 在指定位置设置字符串的字号
    /// - Parameters:
    ///   - range: 位置
    ///   - font: 字号
    /// - Returns: NSMutableAttributedString
    public func xnRangeFont(_ range: NSRange?, _ font: UIFont? = UIFont.systemFont(ofSize: 14)) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.font: font]
        addAttributes(attrs as [NSAttributedString.Key : Any], range: range ?? NSRange(location: 0, length: string.count))
        return self
    }
    
    /// 在指定位置设置字符串的颜色
    /// - Parameters:
    ///   - range: 位置
    ///   - color: 色值
    /// - Returns: NSMutableAttributedString
    public func xnRangeColor(_ range: NSRange?, _ color: UIColor? = .black) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.foregroundColor: color]
        addAttributes(attrs as [NSAttributedString.Key : Any], range: range ?? NSRange(location: 0, length: string.count))
        return self
    }
    
    /// 在指定位置设置字符串的颜色和字号
    /// - Parameters:
    ///   - range: 位置
    ///   - color: 色值
    ///   - font: 字号
    /// - Returns: NSMutableAttributedString
    public func xnRangeColorFont(_ range: NSRange?, _ color: UIColor? = .black, _ font: UIFont? = UIFont.systemFont(ofSize: 14)) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        addAttributes(attrs as [NSAttributedString.Key : Any], range: range ?? NSRange(location: 0, length: string.count))
        return self
    }
    
    /// 在指定位置设置字符串的划线
    /// - Parameters:
    ///   - range: 位置
    ///   - style: 线段样式
    ///   - color: 色值
    /// - Returns: NSMutableAttributedString
    public func xnUnderline(_ range: NSRange?, _ style: NSUnderlineStyle? = .single, _ color: UIColor? = .black) -> NSMutableAttributedString {
        let attrs = [NSAttributedString.Key.strikethroughStyle: NSNumber(value: style?.rawValue ?? 0), NSAttributedString.Key.strikethroughColor: color]
        addAttributes(attrs as [NSAttributedString.Key : Any], range: range ?? NSRange(location: 0, length: string.count))
        return self
    }
    
}
