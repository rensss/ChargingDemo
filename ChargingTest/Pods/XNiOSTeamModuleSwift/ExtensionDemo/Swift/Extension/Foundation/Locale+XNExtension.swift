//
//  Locale+XNExtension.swift
//  ExtensionSwiftDemo
//
//  Created by Rzk on 2021/5/28.
//

import Foundation
// MARK: - Properties
public extension Locale {
    /// XN: UNIX 语言环境的表示，通常用于规范化
    static var xnPosix: Locale {
        return Locale(identifier: "en_US_POSIX")
    }

    /// XN: 返回bool值，指示区域设置是否为12h格式
    var xnIs12HourTimeFormat: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        dateFormatter.locale = self
        let dateString = dateFormatter.string(from: Date())
        return dateString.contains(dateFormatter.amSymbol) || dateString.contains(dateFormatter.pmSymbol)
    }
}

// MARK: - Functions
public extension Locale {
    /// XN: 获取给定国家/地区代码的国旗表情符号
    /// - Parameter isoRegionCode: 地区代码.
    ///
    /// Adapted from https://stackoverflow.com/a/30403199/1627511
    /// - Returns: A flag emoji string for the given region code (optional).
    static func xnFlagEmoji(forRegionCode isoRegionCode: String) -> String? {
        #if !os(Linux)
        guard isoRegionCodes.contains(isoRegionCode) else { return nil }
        #endif

        return isoRegionCode.unicodeScalars.reduce(into: String()) {
            guard let flagScalar = UnicodeScalar(UInt32(127_397) + $1.value) else { return }
            $0.unicodeScalars.append(flagScalar)
        }
    }
}
