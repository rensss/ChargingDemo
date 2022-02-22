//
//  UIImage+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2020/10/29.
//
import UIKit

extension UIImage {
    
    /// color生成纯色图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 尺寸
    /// - Returns: 返回图片
    public static func xnCreateImageWithColor(color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    public static func xnCreateImageWithColor(color: UIColor) -> UIImage? {
        self.xnCreateImageWithColor(color: color, size: CGSize(width: 1, height: 1))
    }
    
    /// 根据imageSize设置图片的圆角
    /// - Parameters:
    ///   - radius: 圆角大小 (默认:3.0,图片大小)
    ///   - corners: 切圆角的方式 [.topLeft , .topRight]
    ///   - imageSize: 输出图片的大小 (默认图片原大小)
    /// - Returns: 剪切后的图片
    public func xnIsRoundCorner(radius: CGFloat = 3, byRoundingCorners corners: UIRectCorner = .allCorners, imageSize: CGSize?) -> UIImage? {
        let weakSize = imageSize ?? self.size
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: weakSize)
        // 开始图形上下文,opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
        UIGraphicsBeginImageContextWithOptions(weakSize, false, UIScreen.main.scale)
        guard let contentRef: CGContext = UIGraphicsGetCurrentContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 绘制路线
        contentRef.addPath(UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: corners,
                                        cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        // 裁剪
        contentRef.clip()
        // 将原图片画到图形上下文
        self.draw(in: rect)
        contentRef.drawPath(using: .stroke)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 设置圆形图片
    /// - Returns: 圆形图片
    public func xnIsCircleImage() -> UIImage? {
        return xnIsRoundCorner(radius: (self.size.width < self.size.height ? self.size.width : self.size.height) / 2.0, byRoundingCorners: .allCorners, imageSize: self.size)
    }
    
    /// 剪裁图片
    /// @param borderWidth 边宽
    /// @param borderColor 描边颜色
    public func xnClipCircleImage(borderWidth: CGFloat = 1,color: UIColor) -> UIImage? {
        let imageW = self.size.width + 2 * borderWidth
        let imageH = self.size.height + 2 * borderWidth
        let newImageSize = CGSize(width: imageW, height: imageH)
        // 开始图形上下文,opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
        UIGraphicsBeginImageContextWithOptions(newImageSize, false, UIScreen.main.scale)
        // 获取上下文
        guard let contentRef: CGContext = UIGraphicsGetCurrentContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 3.画边框(大圆)
        color.set()
        let bigRadius = imageW * 0.5 // 大圆半径
        let centerX = bigRadius //圆心
        let centerY = bigRadius
        contentRef.addArc(center: CGPoint(x: centerX, y: centerY), radius: bigRadius, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: false)
        contentRef.fillPath()
        // 4.小圆
        let smallRadius = bigRadius - borderWidth
        contentRef.addArc(center: CGPoint(x: centerX, y: centerY), radius: smallRadius, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: false)
        contentRef.clip()
        self.draw(in: CGRect(x: 0, y: 0, width: imageW, height: imageH))
        guard let output = UIGraphicsGetImageFromCurrentImageContext() else {
            // 关闭上下文
            UIGraphicsEndImageContext()
            return nil
        }
        // 关闭上下文
        UIGraphicsEndImageContext()
        return output
        
    }
    
    /// 生成渐变色的图片 ["#B0E0E6", "#00CED1", "#2E8B57"]
    /// - Parameters:
    ///   - hexsString: 十六进制字符数组
    ///   - size: 图片大小
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 渐变的图片
    public static func xnGradient(_ hexsString: [String], size: CGSize = CGSize(width: 1, height: 1), locations:[CGFloat]? = nil, direction: XNImageGradientDirection = .horizontal) -> UIImage? {
        return xnGradient(hexsString.map{ UIColor(hexString: $0) ?? UIColor.white }, size: size, locations: locations, direction: direction)
    }
    
    /// 生成渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 渐变的图片
    public static func xnGradient(_ colors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations:[CGFloat]? = nil, direction: XNImageGradientDirection = .horizontal) -> UIImage? {
        return xnGradient(colors, size: size, radius: 0, locations: locations, direction: direction)
    }
    
    /// 生成带圆角渐变色的图片 [UIColor, UIColor, UIColor]
    /// - Parameters:
    ///   - colors: UIColor 数组
    ///   - size: 图片大小
    ///   - radius: 圆角
    ///   - locations: locations 数组
    ///   - direction: 渐变的方向
    /// - Returns: 带圆角的渐变的图片
    public static func xnGradient(_ colors: [UIColor],
                         size: CGSize = CGSize(width: 10, height: 10),
                         radius: CGFloat,
                         locations:[CGFloat]? = nil,
                         direction: XNImageGradientDirection = .horizontal) -> UIImage? {
        if colors.count == 0 { return nil }
        if colors.count == 1 {
            return xnCreateImageWithColor(color: colors[0])
        }
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors.map{$0.cgColor} as CFArray, locations: locations?.map { CGFloat($0) }) else { return nil
        }
        let directionPoint = direction.point(size: size)
        context?.drawLinearGradient(gradient, start: directionPoint.0, end: directionPoint.1, options: .drawsBeforeStartLocation)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 修改图片颜色
    public func xnChangeImageColor(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context?.clip(to: rect, mask: self.cgImage!);
        color.setFill()
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // 图片缩放
    public func xnScaleImage(toSize:CGSize) -> UIImage? {
        //获得原图像的 大小 宽  高
        let imageSize = self.size
        let width = imageSize.width
        let height = imageSize.height
        
        //计算图像新尺寸与旧尺寸的宽高比例
        let widthFactor = toSize.width/width
        let heightFactor = toSize.height/height
        //获取最小的比例
        let scalerFactor = (widthFactor < heightFactor) ? widthFactor : heightFactor
        
        //计算图像新的高度和宽度，并构成标准的CGSize对象
        let scaledWidth = width * scalerFactor
        let scaledHeight = height * scalerFactor
        let targetSize = CGSize(width: scaledWidth, height: scaledHeight)
        
        //创建绘图上下文环境
        UIGraphicsBeginImageContext(targetSize)
        self.draw(in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

public enum XNImageGradientDirection {
    case horizontal             // 水平从左到右
    case vertical               // 垂直从上到下
    case leftOblique            // 左上到右下
    case rightOblique           // 右上到左下
    case other(CGPoint, CGPoint)
    
    public func point(size: CGSize) -> (CGPoint, CGPoint) {
        switch self {
        case .horizontal:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: 0))
        case .vertical:
            return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: size.height))
        case .leftOblique:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: size.height))
        case .rightOblique:
            return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
        case .other(let stat, let end):
            return (stat, end)
        }
    }
}
