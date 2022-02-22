//
//  NSUserDefaults+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by 惊小鱼 on 2021/7/22.
//

import Foundation

extension UserDefaults {
    
    func xnClearAll() {
        let dict = dictionaryRepresentation()
        for key in dict.keys {
            self.removeObject(forKey: key)
        }
        synchronize()
    }
    
}
