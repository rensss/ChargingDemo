//
//  UITabBar+XNExtension.swift
//  XNUtilsSwiftSupplement
//
//  Created by iMac on 2021/7/22.
//

import UIKit

public enum CustomBadgeType {
    case kCustomBadgeStyleRedDot
    case kCustomBadgeStyleNumber
    case kCustomBadgeStyleNone
}

let kBadgeViewInitedKey = "kBadgeViewInited"
let kBadgeDotViewsKey = "kBadgeDotViewsKey"
let kBadgeNumberViewsKey = "kBadgeNumberViewsKey"
let RedPointOrigin_W = 16



extension UITabBar {
    
    public func xnSetBadgeStyle(type:CustomBadgeType, badgeValue:NSInteger, index:NSInteger) {
        
        if (!(self.value(forKey: kBadgeViewInitedKey) as? Bool ?? false)) {
            self.setValue(true, forKey: kBadgeViewInitedKey)
            addBadgeViews()
        }
        
        let badgeDotViews:[UIView] = self.value(forKey: kBadgeDotViewsKey) as? Array<UIView> ?? []
        let badgeNumberViews:[UILabel] = self.value(forKey: kBadgeNumberViewsKey) as? Array<UILabel> ?? []
        badgeDotViews[index].isHidden = true
        badgeNumberViews[index].isHidden = true
        if type == .kCustomBadgeStyleRedDot {
            badgeDotViews[index].isHidden = false
        } else if type == .kCustomBadgeStyleNumber {
            badgeNumberViews[index].isHidden = false
            let label = badgeNumberViews[index]
            adjustBadgeNumberViewWithLabel(label: label, number: badgeValue)
        } else if type == .kCustomBadgeStyleNone {
            badgeDotViews[index].isHidden = true
            badgeNumberViews[index].isHidden = true
        }
        
    }
    
    func addBadgeViews() {
        let tabIconWidth: CGFloat = 32
        let badgeTop:CGFloat = 9
        let itemsCount =  self.items?.count
        let itemWidth = self.bounds.size.width/CGFloat(itemsCount ?? 0)
        
        //dot views
        var badgeDotViews = Array<UIView>()
        for i in 0..<(itemsCount ?? 0) {
            let redDot = UIView()
            redDot.bounds = CGRect(x: 0, y: 0, width: 8, height: 8)
            redDot.center = CGPoint(x: itemWidth*(CGFloat(i)+0.5)+tabIconWidth/2, y: badgeTop)
            redDot.layer.cornerRadius = redDot.bounds.size.width/2
            redDot.clipsToBounds = true
            redDot.backgroundColor = .red
            redDot.isHidden = true
            self.addSubview(redDot)
            badgeDotViews.append(redDot)
        }
        self.setValue(badgeDotViews, forKey: kBadgeDotViewsKey)
        
        //number views
        var badgeNumberViews = Array<UILabel>()
        for i in 0..<(itemsCount ?? 0) {
            let redNum = UILabel()
            redNum.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
            redNum.bounds = CGRect(x: 0, y: 0, width: RedPointOrigin_W, height: RedPointOrigin_W)
            redNum.center = CGPoint(x: itemWidth*(CGFloat(i)+0.5)+2, y: badgeTop)
            redNum.layer.cornerRadius = redNum.bounds.size.height/2
            redNum.clipsToBounds = true
            redNum.backgroundColor = .red
            redNum.isHidden = true
            redNum.textAlignment = .center
            redNum.font = UIFont.boldSystemFont(ofSize: 11)
            redNum.textColor = .white
            self.addSubview(redNum)
            badgeNumberViews.append(redNum)
        }
        self.setValue(badgeNumberViews, forKey: kBadgeNumberViewsKey)
    }
    
    func adjustBadgeNumberViewWithLabel(label:UILabel, number:NSInteger) {
        label.text = number > 999 ? "..." : String(number)
        if number < 10 {
            label.bounds = CGRect(x: 0, y: 0, width: RedPointOrigin_W, height: RedPointOrigin_W)
        } else if number < 100 {
            label.bounds = CGRect(x: 0, y: 0, width: RedPointOrigin_W + 6, height: RedPointOrigin_W)
        } else if number < 1000 {
            label.bounds = CGRect(x: 0, y: 0, width: RedPointOrigin_W + 12, height: RedPointOrigin_W)
        } else {
            label.bounds = CGRect(x: 0, y: 0, width: RedPointOrigin_W + 6, height: RedPointOrigin_W)
        }
    }
    
    
    open override func setValue(_ value: Any?, forUndefinedKey key: String) {
        objc_setAssociatedObject(self, key, value,
                                             .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
    }
    
    open override func value(forUndefinedKey key: String) -> Any? {
        objc_getAssociatedObject(self, key)
    }
    
}
