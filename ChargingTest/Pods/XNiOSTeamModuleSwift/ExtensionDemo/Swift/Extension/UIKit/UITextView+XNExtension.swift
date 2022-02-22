//
//  UITextView+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by Rzk on 2021/4/1.
//

import UIKit

public typealias xnURLClickClosure = (UITextView, URL, NSRange, UITextItemInteraction) -> (Bool)

extension UITextView: UITextViewDelegate {
    private struct AssociatedKey {
        static var clickCallbackKey: String = "clickCallbackKey"
    }
    
    private var clickCallback: xnURLClickClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.clickCallbackKey) as? xnURLClickClosure
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.clickCallbackKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public func xnClickCallback(attributedText: NSAttributedString, handler: @escaping xnURLClickClosure) {
        self.delegate = self
        self.clickCallback = handler
        self.attributedText = attributedText
    }
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.clickCallback?(textView, URL, characterRange, interaction) ?? false
    }
    
}
