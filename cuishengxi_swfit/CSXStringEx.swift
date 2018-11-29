//
//  CSXStringEx.swift
//  cuishengxi
//
//  Created by 崔盛希 on 2018/11/29.
//

import Foundation

/**
 * 向String添加了一些有用的方法
 *
 * - author: cuishengxi
 * - version: 1.0
 */
extension String {
    
    /// the length of the string
    public var length: Int {
        return self.count
    }
    
    /// Get string without spaces at the end and at the start.
    ///
    /// - Returns: trimmed string
    public func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    /// Checks if string contains given substring
    ///
    /// - Parameters:
    ///   - substring: the search string
    ///   - caseSensitive: flag: true - search is case sensitive, false - else
    /// - Returns: true - if the string contains given substring, false - else
    public func contains(_ substring: String, caseSensitive: Bool = true) -> Bool {
        if let _ = self.range(of: substring,
                              options: caseSensitive ? NSString.CompareOptions(rawValue: 0) : .caseInsensitive) {
            return true
        }
        return false
    }
    
    /// Checks if string contains given substring
    ///
    /// - Parameter find: the search string
    /// - Returns: true - if the string contains given substring, false - else
    public func contains(_ find: String) -> Bool{
        if let _ = self.range(of: find){
            return true
        }
        return false
    }
    
    /// Shortcut method for replacingOccurrences
    ///
    /// - Parameters:
    ///   - target: the string to replace
    ///   - withString: the string to add instead of target
    /// - Returns: a result of the replacement
    public func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString,
                                         options: NSString.CompareOptions.literal, range: nil)
    }
    
    /// Replaces all characters that match the given regular string
    ///
    /// - Parameter regularString: the regular string
    /// - Returns: a result of the replacement
    public func replaceRegex(regularString: String) -> String {
        if let regex = try? NSRegularExpression(pattern: regularString, options: NSRegularExpression.Options.init(rawValue: 0)) {
            return regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.length), withTemplate: "")
        }
        return self
    }
    
    /// Checks if the string is number
    ///
    /// - Returns: true if the string presents number
    public func isNumber() -> Bool {
        let formatter = NumberFormatter()
        if let _ = formatter.number(from: self) {
            return true
        }
        return false
    }
    
    /// Checks if the string is positive number
    ///
    /// - Returns: true if the string presents positive number
    public func isPositiveNumber() -> Bool {
        let formatter = NumberFormatter()
        if let number = formatter.number(from: self) {
            if number.doubleValue > 0 {
                return true
            }
        }
        return false
    }
    
    /// Get URL encoded string
    ///
    /// - Returns: URL encoded string
    public func urlEncodedString() -> String {
        var set = CharacterSet.urlQueryAllowed
        set.remove(charactersIn: ":?&=@+/'")
        return self.addingPercentEncoding(withAllowedCharacters: set) ?? self
    }
    
    /// Encode current string with Base64 algorithm
    ///
    /// - Returns: the encoded string
    public func encodeBase64() -> String {
        let utf8str = self.data()
        return utf8str?.base64EncodedString() ?? self
    }
    
    /// Truncate string with given length
    ///
    /// - Parameters:
    ///   - length: the length
    ///   - trailing: the trailing
    /// - Returns: truntacted string
    public func truncate(length: Int, trailing: String? = "...") -> String {
        if self.length > length {
            return self[..<self.index(self.startIndex, offsetBy: length)] + (trailing ?? "")
        } else {
            return self
        }
    }
    
    /// Get last path, e.g. "domain.com/folder/something" -> "something"
    ///
    /// - Returns: the last path
    public func lastPath() -> String {
        let splited = self.components(separatedBy: "/")
        if let last = splited.last {
            return last
        }
        return ""
    }
    
    /// Encode string to data
    ///
    /// - Returns: the data
    public func data() -> Data? {
        return self.data(using: .utf8)
    }
    
    /// Get string from resource file
    ///
    /// - Parameter name: resource name
    /// - Returns: resource content or nil
    public static func resource(named name: String) -> String? {
        guard let resourceUrl = Bundle.main.url(forResource: name, withExtension: "string") else {
            fatalError("Could not find resource \(name)")
        }
        
        // create data from the resource content
        var data: Data
        do {
            data = try Data(contentsOf: resourceUrl, options: Data.ReadingOptions.mappedIfSafe) as Data
        } catch let error {
            print("ERROR: \(error)")
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    /// Add zeros on left, e.g. "5" -> "05"
    ///
    /// - Parameter targetLength: the target length of the string
    public func addZeros(targetLength: Int = 2) -> String {
        var str = self
        while str.length < targetLength {
            str = "0\(str)"
        }
        return str
    }
    
    /// Get substring, e.g. "ABCDE".substring(index: 2, length: 3) -> "CDE"
    ///
    /// - parameter index:  the start index
    /// - parameter length: the length of the substring
    ///
    /// - returns: the substring
    public func substring(index: Int, length: Int) -> String {
        if self.length <= index {
            return ""
        }
        let leftIndex = self.index(self.startIndex, offsetBy: index)
        if self.length <= index + length {
            return String(self[leftIndex..<self.endIndex])
        }
        let rightIndex = self.index(self.endIndex, offsetBy: -(self.length - index - length))
        return String(self[leftIndex..<rightIndex])
    }
    
    /// Get substring, e.g. -> "ABCDE".substring(left: 0, right: 2) -> "ABC"
    ///
    /// - parameter left:  the start index
    /// - parameter right: the end index
    ///
    /// - returns: the substring
    public func substring(left: Int, right: Int) -> String {
        if length <= left {
            return ""
        }
        let leftIndex = self.index(self.startIndex, offsetBy: left)
        if length <= right {
            return String(self[leftIndex..<self.endIndex])
        }
        else {
            let rightIndex = self.index(self.endIndex, offsetBy: -self.length + right + 1)
            return String(self[leftIndex..<rightIndex])
        }
    }
    
    /// Replace quotes to allow to use in SQL, e.g. 'Cool "Title"' -> '"Cool \"Title\""'
    ///
    /// - Returns: the modified string
    public func sqlValue() -> String {
        return "\"\(self.replace("\"", withString: "\\\""))\""
    }
    
    /// Abbreviation, e.g. "Swift extensions" -> "SE"
    public var abbreviation: String {
        let a = self.split(separator: " ")
        return a.map({String($0.first!).uppercased()}).joined()
    }
}

