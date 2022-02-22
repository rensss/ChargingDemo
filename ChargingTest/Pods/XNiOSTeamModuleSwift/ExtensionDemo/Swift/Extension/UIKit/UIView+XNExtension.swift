//
//  UIView+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2020/10/29.
//

import UIKit

enum xnShakeAnimationDirection {
    case upDown
    case leftRight
}

extension UIView {
    /// .x
    public var xnX: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var rect = self.frame
            rect.origin.x = newValue
            self.frame = rect
        }
    }
    
    /// .y
    public var xnY: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    
    /// .maxX
    public var xnMaxX: CGFloat {
        get {
            return self.frame.maxX
        }
    }
    
    /// .maxY
    public var xnMaxY: CGFloat {
        get {
            return self.frame.maxY
        }
    }
    
    /// .centerX
    public var xnCenterX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y:self.center.y)
        }
    }
    
    /// .centerY
    public var xnCenterY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    /// .width
    public var xnWidth: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var rect = self.frame
            rect.size.width = newValue
            self.frame = rect
        }
    }
    
    /// .height
    public var xnHeight: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var rect = self.frame
            rect.size.height = newValue
            self.frame = rect
        }
    }
    
    /// .size
    public var xnSize: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    /// XN: 边框颜色
    @IBInspectable var xnBorderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    /// XN: 边框宽度
    @IBInspectable var xnBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// XN: 圆角大小
    @IBInspectable var xnBcornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    /// XN: 生成截屏图片
    var xnScreenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// XN: 阴影颜色
    @IBInspectable var xnLayerShadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// XN: 阴影偏移量
    @IBInspectable var xnLayerShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// XN: 阴影透明度
    @IBInspectable var xnLayerShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// XN: 阴影的圆角
    @IBInspectable var xnLayerShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// XN: 是否mask边界
    @IBInspectable var xnMasksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
}

extension UIView {
    
    /// XN: Angle units.
    ///
    /// - degrees: degrees.
    /// - radians: radians.
    enum AngleUnit {
        /// XN: degrees.
        case degrees
        
        /// XN: radians.
        case radians
    }
    
    // MARK:- func
    /// 抖动动画
    /// - Parameters:
    ///   - direction: 方向
    ///   - duration: 时长
    ///   - distance: 位移
    ///   - repeatCount: 重复次数
    func xnStartShakeAnimation(_ direction: xnShakeAnimationDirection, duration: CFTimeInterval, distance: CGFloat, repeatCount: Float) {
        
        let shakeAnim = CAKeyframeAnimation()
        
        switch direction {
        case .upDown:
            shakeAnim.keyPath = "transform.translation.y"
        case .leftRight:
            shakeAnim.keyPath = "transform.translation.x"
        }
        shakeAnim.duration = duration;
        shakeAnim.values = [0 , -distance, distance, 0];
        shakeAnim.repeatCount = repeatCount;
        self.layer.add(shakeAnim, forKey: "shakeAnim")
    }
    
    func xnStartShakeAnimation() {
        self.xnStartShakeAnimation(.leftRight, duration: 0.25, distance: 10, repeatCount: 4)
    }
    
    /// 添加闪动layer
    /// - Parameters:
    ///   - gradientLayer: 对应的layer
    ///   - duration: 时长
    ///   - layerWidth: layer宽度
    ///   - distance: 距离
    func xnStartFlashAnimationWithGradientLayer(_ gradientLayer:CAGradientLayer, duration: CFTimeInterval, layerWidth: CGFloat, distance: CGFloat) {
        
        let animation = CAKeyframeAnimation()
        animation.duration = duration
        animation.keyPath = "transform.translation.x";
        animation.values = [-distance, self.bounds.size.width + layerWidth + distance];
        animation.repeatCount = MAXFLOAT;
        gradientLayer.add(animation, forKey: "FlashAnimation")
    }
    
    func xnStartFlashAnimationWithGradientLayer(_ gradientLayer:CAGradientLayer) {
        self.xnStartFlashAnimationWithGradientLayer(gradientLayer, duration: 3, layerWidth: 15, distance: 150)
    }
    
    /// 一侧切圆角
    /// - Parameters:
    ///   - corners: 边
    ///   - radii: 角度
    func xnCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// XN: 在相对轴上以角度旋转视图
    ///
    /// - Parameters:
    ///   - angle: 旋转视图的角度
    ///   - type: 旋转角度的类型
    ///   - animated: 设置true以设置旋转动画（默认值为true）
    ///   - duration: 以秒为单位的动画持续时间（默认值为1秒）
    ///   - completion: 可选的完成处理程序，用于在动画完成时运行（默认值为nil）
    func xnRotate(byAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.transform = self.transform.rotated(by: angleWithType)
        }, completion: completion)
    }
    
    /// XN: 将视图旋转到固定轴上的角度
    ///
    /// - Parameters:
    ///   - angle: 旋转视图的角度
    ///   - type: 旋转角度的类型
    ///   - animated: 设置true以设置旋转动画（默认值为false）
    ///   - duration: 以秒为单位的动画持续时间（默认值为1秒）
    ///   - completion: 可选的完成处理程序，用于在动画完成时运行（默认值为nil）
    func xnRotate(toAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, animations: {
            self.transform = self.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
        }, completion: completion)
    }
    
    /// XN: 按偏移量缩放视图
    ///
    /// - Parameters:
    ///   - offset: 偏移量
    ///   - animated: 设置true以设置缩放动画（默认值为false）
    ///   - duration: 以秒为单位的动画持续时间（默认值为1秒）
    ///   - completion: 可选的完成处理程序，用于在动画完成时运行（默认值为nil）
    func xnScale(by offset: CGPoint, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
                self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
            }, completion: completion)
        } else {
            transform = transform.scaledBy(x: offset.x, y: offset.y)
            completion?(true)
        }
    }
}
