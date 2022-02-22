//
//  Array+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2021/5/21.
//

import Foundation

extension Array {
    
    /// 获取数组中的元素，增加了防止数组越界的判断
    public func xnSafeIndex(_ i: Int) -> Array.Iterator.Element? {
        guard !isEmpty && self.count > abs(i) else {
            return nil
        }
        
        let idx = i > 0 ? i : (count+i)
        return self[idx]
    }
    
    /// 从前面取 N 个数组元素
    public func xnLimit(_ limitCount: Int) -> [Array.Iterator.Element] {
        let maxCount = self.count
        var resultCount: Int = limitCount
        if maxCount < limitCount {
            resultCount = maxCount
        }
        if resultCount <= 0 {
            return []
        }
        return self[0..<resultCount].map { $0 }
    }
    
  /// 数组去重
    public func xnFilterDuplicates<E: Equatable>(_ filter:(Element) -> E) -> [Element] {
        var result = [Element]()
        var keyArr = [E]()
        
        for value in self {
            let key = filter(value)
            
            if !keyArr.contains(key){
                keyArr.append(key)
                result.append(value)
            }
            
        }
        return result
    }

}

extension Array where Element:Hashable {
    var unique:[Element] {
        var uniq = Set<Element>()
        uniq.reserveCapacity(self.count)
        return self.filter {
            return uniq.insert($0).inserted
        }
    }
}
