//
//  UIColor+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by Rzk on 2021/3/26.
//

import UIKit

extension UIColor {
    
    /// 根据 RGBA 设置颜色
    /// - Parameters:
    ///   - r: red 颜色值
    ///   - g: green颜色值
    ///   - b: blue颜色值
    ///   - alpha: 透明度
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        // 提示：在 extension 中给系统的类扩充构造函数，只能扩充：遍历构造函数
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 十六进制字符串设置颜色
    /// - Parameters:
    ///   - hex: 十六进制字符串
    ///   - alpha: 透明度
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        let color = Self.xnHexStringToColorRGB(hexString: hexString)
        guard let r = color.r, let g = color.g, let b = color.b else {
            #if DEBUG
            assert(false, "不是十六进制值")
            #endif
            return nil
        }
        self.init(r: r, g: g, b: b, alpha: alpha)
    }
    
    /// 十六进制 Int 设置颜色
    /// - Parameters:
    ///   - hexInt: 十六进制 Int 值
    ///   - alpha:  透明度
    convenience init(hexInt: Int, alpha: CGFloat = 1.0) {
        let color = Self.xnHexIntToColorRGB(hexInt: hexInt)
        self.init(r: color.r, g: color.g, b: color.b, alpha: alpha)
    }
    
    /// 十六进制字符串设置颜色(方法)
    public static func xnHexStringColor(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        let newColor = xnHexStringToColorRGB(hexString: hexString)
        guard let r = newColor.r, let g = newColor.g, let b = newColor.b else {
            assert(false, "颜色值有误")
            return .white
        }
        return UIColor(r: r, g: g, b: b, alpha: alpha)
    }
    
    /// 根据 十六进制字符串 颜色获取 RGB
    /// - Parameter hexString: 十六进制颜色的字符串，如：#3CB371 或者 ##3CB371 -> 60,179,113
    /// - Returns: 返回 RGB
    public static func xnHexStringToColorRGB(hexString: String) -> (r: CGFloat?, g: CGFloat?, b: CGFloat?) {
        // 1、判断字符串的长度是否符合
        guard hexString.count >= 6 else { return (nil, nil, nil) }
        // 2、将字符串转成大写
        var tempHex = hexString.uppercased()
        // 检查字符串是否拥有特定前缀
        // hasPrefix(prefix: String)
        // 检查字符串是否拥有特定后缀。
        // hasSuffix(suffix: String)
        // 3、判断开头： 0x/#/##
        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##") {
            tempHex = String(tempHex[tempHex.index(tempHex.startIndex, offsetBy: 2)..<tempHex.endIndex])
        }
        if tempHex.hasPrefix("#") {
            tempHex = String(tempHex[tempHex.index(tempHex.startIndex, offsetBy: 1)..<tempHex.endIndex])
        }
        // 4、分别取出 RGB
        // FF --> 255
        var range = NSRange(location: 0, length: 2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        // 5、将十六进制转成 255 的数字
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        return (r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
    }
    
    /// 根据 十六进制值 颜色获取 RGB， 如：0x3CB371 -> 60,179,113
    /// - Parameter hexInt: 十六进制值，如：0x3CB37
    /// - Returns: 返回 RGB
    public static func xnHexIntToColorRGB(hexInt: Int) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        let red: CGFloat = CGFloat(hexInt >> 16)
        let green: CGFloat = CGFloat((hexInt & 0xFF00) >> 8)
        let blue: CGFloat = CGFloat(hexInt & 0xFF)
        return (red, green, blue)
    }
    
    /// 生成随机色
    /// - Returns: 随机颜色
    public static func xnRandomColor() -> UIColor {
        return UIColor(r: CGFloat.random(in: 0..<256), g: CGFloat.random(in: 0..<256), b: CGFloat.random(in: 0..<256))
    }
    
}
