//
//  Date+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by xnhl_iosQ on 2020/10/29.
//

import UIKit

extension Date {
    
    /// 将date按照设置的格式转化为String
    /// - Parameters:
    ///   - format: 时间格式
    /// - Returns: 转化后的String
    public func xnStringWithFormatter(formatter: String) -> String {
        return self.xnStringWithFormatterAndLocal(formatter: formatter, local: NSLocale.current.identifier)
    }
    
    /// 将date按照设置的格式转化为string
    /// - Parameters:
    ///   - format: 时间格式
    ///   - local: 地区 eg： en_US
    /// - Returns: 转化后的String
    public func xnStringWithFormatterAndLocal(formatter: String, local: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: local) as Locale
        dateFormatter.dateFormat = formatter
        return dateFormatter.string(from: self)
    }
    
    /// 将date按照设置的样式转化为string
    /// - Parameters:
    ///   - style: 日期取值格式样式 eg： 下午7:00:00 2013年5月19日
    /// - Returns: 转化后的String
    public func xnStringWithStyle(style: DateFormatter.Style) -> String {
        return self.xnStringWithStyleAndLocal(style: style, local: NSLocale.current.identifier)
    }
    
    /// 将date按照设置的样式转化为string
    /// - Parameters:
    ///   - style: 日期取值格式样式 eg： 下午7:00:00 2013年5月19日
    ///   - local: 地区 eg： en_US
    /// - Returns: 转化后的String
    public func xnStringWithStyleAndLocal(style: DateFormatter.Style, local: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: local) as Locale
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
    
    // 获取当前日期属于的年
    public func xnCurrentYear() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        return components.year ?? 0
    }
    
    // 获取当前日期属于的月
    public func xnCurrentMonth() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: self)
        return components.month ?? 0
    }
    
    // 获取当前日期属于的日
    public func xnCurrentDay() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self)
        return components.day ?? 0
    }
    
    // 当前星期几
    public func xnCurrentWeekday() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self)
        let currentWeekday = components.weekday ?? 0
        return  currentWeekday - 1
    }
    
    // 当前小时
    public func xnCurrentHour() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: self)
        return  components.hour ?? 0
    }
    
    // 当前分钟
    public func xnCurrentMinute() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: self)
        return  components.minute ?? 0
    }
    
    // 当前秒数
    public func xnCurrentSecond() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: self)
        return  components.second ?? 0
    }
    
    // 获取属于的月份里一共有几天
    public func xnDaysOfMonth() -> Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)
        return (range?.count) ?? 0
    }
    
    // 获取是上午还是下午
    public func xnDateIsPMOrAM() -> String {
        return xnCurrentHour() > 12 ? "PM" : "AM"
    }
    
    // 分别输入数字转化为完整日期
    public static func xnGetDateWithYear(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents.init()
        components.year = year
        components.month = month
        components.day = day
        
        let calendar = Calendar.current
        let date = calendar.date(from: components)
        return date!
    }

}
