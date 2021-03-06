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
    
    /// XN: ????????????
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
    
    /// XN: ????????????
    @IBInspectable var xnBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// XN: ????????????
    @IBInspectable var xnBcornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    /// XN: ??????????????????
    var xnScreenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// XN: ????????????
    @IBInspectable var xnLayerShadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// XN: ???????????????
    @IBInspectable var xnLayerShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// XN: ???????????????
    @IBInspectable var xnLayerShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// XN: ???????????????
    @IBInspectable var xnLayerShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// XN: ??????mask??????
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
    /// ????????????
    /// - Parameters:
    ///   - direction: ??????
    ///   - duration: ??????
    ///   - distance: ??????
    ///   - repeatCount: ????????????
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
    
    /// ????????????layer
    /// - Parameters:
    ///   - gradientLayer: ?????????layer
    ///   - duration: ??????
    ///   - layerWidth: layer??????
    ///   - distance: ??????
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
    
    /// ???????????????
    /// - Parameters:
    ///   - corners: ???
    ///   - radii: ??????
    func xnCorner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    /// XN: ????????????????????????????????????
    ///
    /// - Parameters:
    ///   - angle: ?????????????????????
    ///   - type: ?????????????????????
    ///   - animated: ??????true????????????????????????????????????true???
    ///   - duration: ???????????????????????????????????????????????????1??????
    ///   - completion: ???????????????????????????????????????????????????????????????????????????nil???
    func xnRotate(byAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.transform = self.transform.rotated(by: angleWithType)
        }, completion: completion)
    }
    
    /// XN: ???????????????????????????????????????
    ///
    /// - Parameters:
    ///   - angle: ?????????????????????
    ///   - type: ?????????????????????
    ///   - animated: ??????true????????????????????????????????????false???
    ///   - duration: ???????????????????????????????????????????????????1??????
    ///   - completion: ???????????????????????????????????????????????????????????????????????????nil???
    func xnRotate(toAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, animations: {
            self.transform = self.transform.concatenating(CGAffineTransform(rotationAngle: angleWithType))
        }, completion: completion)
    }
    
    /// XN: ????????????????????????
    ///
    /// - Parameters:
    ///   - offset: ?????????
    ///   - animated: ??????true????????????????????????????????????false???
    ///   - duration: ???????????????????????????????????????????????????1??????
    ///   - completion: ???????????????????????????????????????????????????????????????????????????nil???
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
