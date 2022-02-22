//
//  String+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2020/10/30.
//

import UIKit

extension String {

    //MARK:字符串截取
    /// 截取字符串中某个位置的单个字符 string[index] 例如："abcdefg"[3] // c
    /// - Parameters:
    ///   - atIndex: 某个位置的index
    /// - Returns: 截取后的字符串
    public func xnSubString (atIndex:Int)->String?{
        if(atIndex >= self.count || atIndex < 0){
            return nil
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: atIndex)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }
    /// 截取字符串中从第几个到第几个的字符串  string[上标..<下标] 例如："abcdefg"[3..<4] // d
    /// - Parameters:
    ///   - rangeBound: [上标..<下标]
    /// - Returns: 截取后的字符串
    public func xnSubString (rangeBound: Range<Int>) -> String? {
        if(rangeBound.lowerBound >= self.count || rangeBound.lowerBound < 0){
            return nil
        }else if(rangeBound.upperBound >= self.count || rangeBound.upperBound < 0){
            return nil
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: rangeBound.lowerBound)
        let endIndex = self.index(self.startIndex, offsetBy: rangeBound.upperBound)
        return String(self[startIndex..<endIndex])
        
    }
    
    /// 截取字符串中从index开始长度为几的子串  string[fromIndex,length] 例如："abcdefg"[3,2] // de
    /// - Parameters:
    ///   - fromIndex: 从某个位置开始
    ///   - length:    长度是多少
    /// - Returns: 截取后的字符串
    public func xnSubString (fromIndex:Int , length:Int) -> String? {
        if(fromIndex >= self.count || fromIndex < 0 || length < 0){
            return nil
        }
        if((fromIndex + length) > self.count || (fromIndex + length) < 0){
            return nil
        }
        
        let startIndex = self.index(self.startIndex, offsetBy: fromIndex)
        let endIndex = self.index(startIndex, offsetBy: length)
        return String(self[startIndex..<endIndex])
    }
    
    /// 获取2个字符之间的字符串(只对第一组目标字符串有效)
    /// - Parameters:
    ///   - firstCharacter:     第一个字符
    ///   - secondCharacter:    第二个字符
    /// - Returns:返回目标字符串
    public func xnSubStringBetweenCharacters(firstString: Character,sencondString:Character) -> String? {
        if firstString != sencondString {
            if let index1 = self.firstIndex(of: firstString),
               let index2 = self.firstIndex(of: sencondString)
            {
                if index2 > index1  {
                    var subString = self[index1...index2]
                    subString.removeLast()
                    subString.removeFirst()
                    return String(subString)
                }
            }
            return nil
        }else{
            let arr =  self.components(separatedBy: String(firstString))as Array  //eg. 66#17601021332#99
            if arr.count >= 2 {
                let firstIndex = arr[0].count > 0 ? arr[0].count - 1 : 0
                let secondIndex = arr[1].count > 0 ?  (arr[0].count + 1) + arr[1].count : arr[0].count
                if let resultStr = self.xnSubString(rangeBound:firstIndex ..< secondIndex + 1) {
                    let finialStr =  resultStr.replacingOccurrences(of: String(firstString), with: "")
                    return finialStr
                }
            }
        }
        return nil
    }
    
    /// 一串字符串的宽度
    /// - Parameter font: 字号
    /// - Returns: 宽度
    public func xnCalculateStringWidth(font: UIFont) -> CGFloat {
        let attrs = [NSAttributedString.Key.font: font]
        let tempRect = (self as NSString).boundingRect(with: CGSize(width: 0, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attrs, context: nil)
        return tempRect.size.width
    }
    
    /// 一串固定宽度字符串的高度
    /// - Parameter font: 字号
    /// - Returns: 宽度
    public func xnCalculateStringHeightWithWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        let tempRect = (self as NSString).boundingRect(with: CGSize(width: width, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        return tempRect.size.height
    }
    
    /// 一串固定高度字符串的宽度
    /// - Parameter font: 字号
    /// - Returns: 高度
    public func xnCalculateStringWidthWithHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        
        let tempRect = (self as NSString).boundingRect(with: CGSize(width: 0, height: height), options: NSStringDrawingOptions(rawValue:  NSStringDrawingOptions.usesFontLeading.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.truncatesLastVisibleLine.rawValue), attributes: attributes, context: nil)
        return tempRect.size.width
    }
    
    /// 将dateStr转换成date
    /// - Parameters:
    ///   - dateStr: date的字符串
    ///   - formate: 时间格式
    /// - Returns: Date
    public func xnStringToDate(formatter: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.date(from: self)
        
    }
    
    /// 时间戳转日期字符串
    /// - Parameters:
    ///   - timeInterval: 时间戳（单位：s）
    ///   - formate: 时间格式
    /// - Returns: 转化后的string
    public static func xnTimeIntervalToDateStr(timeInterval: Int, formatter: String) -> String {
        let timeInter = TimeInterval(timeInterval)
        let date = Date(timeIntervalSince1970: timeInter)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: date)
    }
    
    public func xnRemoveWhiteSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    public func xnRemoveWhiteSpaceAndLineBreak() -> String {
        var temp = self.replacingOccurrences(of: "\n", with: "")
        temp = temp.replacingOccurrences(of: "\r", with: "")
        return temp
    }
}
