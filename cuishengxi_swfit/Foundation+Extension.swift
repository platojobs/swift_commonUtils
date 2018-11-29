//
//  Foundation+Extension.swift
//  placeImage
//
//  Created by ZhihuaZhang on 2017/07/15.
//  Copyright © 2017年 Kapps Inc. All rights reserved.
//

import Foundation

private let formatter: NumberFormatter = NumberFormatter()

extension Int {
    // 日本円表記のString
    var JPYString: String {
        return formattedString(style: .currency, localeIdentifier: "ja_JP")
    }
    
    var decimalString: String {
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
    var JPYDecimal: String {
        return "\(decimalString)円"
    }
    
    private func formattedString(style: NumberFormatter.Style, localeIdentifier: String) -> String {
        formatter.numberStyle = style
        formatter.locale = Locale(identifier: localeIdentifier)
        return formatter.string(from: self as NSNumber) ?? ""
    }
}

protocol PropertyNames {
    func propertyNames() -> [String]
}

extension PropertyNames {
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.compactMap { $0.label }
    }
}

extension Double {
    var oneDecimalString: String {
        return String(format: "%.1f", self)
    }
    
    var twoDecimalString: String {
        return String(format: "%.2f", self)
    }
}
