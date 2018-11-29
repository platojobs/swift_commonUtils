//
//  CSXValidationCheck.swift
//  cuishengxi
//
//  Created by 崔盛希 on 2018/11/29.
//

import Foundation

/**
 *  正则表达式的扩展类
 *
 * - author: cuishengxi
 * - version: 1.0
 */
class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.internalExpression = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func test(_ input: String) -> Bool {
        let matches = self.internalExpression.matches(in: input, options: [],
                                                      range: NSMakeRange(0, input.count))
        return matches.count > 0
    }
}
precedencegroup RegexPrecedence {
    lowerThan: AdditionPrecedence
}

// 简洁性定义运算符
infix operator ≈: RegexPrecedence
public func ≈(input: String, pattern: String) -> Bool {
    return Regex(pattern).test(input)
}

/// type alias for the callback used to return an occurred error
public typealias FailureCallback = (String)->()

/**
 * Validation utilities. Helps to check parameters in service methods before sending HTTP request.
 *
 * - author: Alexander Volkov
 * - version: 1.0
 */
public class ValidationUtils {
    
    
    /// Check 'value' if it's not nil and callback failure if it is.
    ///
    /// - Parameters:
    ///   - value: the value to check
    ///   - failure: the closure to invoke if validation fails
    /// - Returns: true if string is not empty
    class func validateNil(value: AnyObject?, _ failure: FailureCallback?) -> Bool {
        if value == nil {
            failure?(NSLocalizedString("Nil Value", comment:"Nil Value"))
            return false
        }
        return true
    }
    
    /// Check URL for correctness and callback failure if it's not.
    ///
    /// - Parameters:
    ///   - url: the URL string to check
    ///   - failure: the closure to invoke if validation fails
    /// - Returns: true if URL is correct
    public class func validate(url: String?, _ failure: FailureCallback?) -> Bool {
        if url == nil || url == "" {
            failure?("Empty URL")
            return false
        }
        if !url!.hasPrefix("http") {
            failure?(NSLocalizedString("URL should start with \"http\"", comment: "URL should start with \"http\""))
            return false
        }
        return true
    }
    
    /// Check 'string' if it's correct ID.
    /// Delegates validation to two other methods.
    ///
    /// - Parameters:
    ///   - id: the id string to check
    ///   - failure: the closure to invoke if validation fails
    /// - Returns: true if string is not empty
    public class func validate(id: String, _ failure: FailureCallback?) -> Bool {
        if !ValidationUtils.validateStringNotEmpty(id, failure) { return false }
        if id.isNumber() && !ValidationUtils.validatePositiveNumber(id, failure) { return false }
        return true
    }
    
    /// Check 'string' if it's empty and callback failure if it is.
    ///
    /// - Parameters:
    ///   - string: the string to check
    ///   - failure: the closure to invoke if validation fails
    /// - Returns: true if string is not empty
    public class func validateStringNotEmpty(_ string: String, _ failure: FailureCallback?) -> Bool {
        if string.isEmpty {
            failure?(NSLocalizedString("Empty string", comment: "Empty string"))
            return false
        }
        return true
    }
    
    /// Check if the string is positive number and if not, then callback failure and return false.
    ///
    /// - Parameters:
    ///   - numberString: the string to check
    ///   - failure: the closure to invoke if validation fails
    /// - Returns: true if given string is positive number
    public class func validatePositiveNumber(_ numberString: String, _ failure: FailureCallback?) -> Bool {
        if !numberString.isPositiveNumber() {
            failure?("Incorrect number: \(numberString)")
            return false
        }
        return true
    }
    
    /// Check if the string represents email
    ///
    /// - Parameters:
    ///   - email: the text to validate
    ///   - failure: the closure to invoke if validation fails
    /// - Returns: true if the given string is a valid email
    public class func validateEmail(_ email: String, _ failure: FailureCallback?) -> Bool {
        let emailPattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$"
        
        if email.trim() ≈ emailPattern {
            return true
        }
        let errorMessage = NSLocalizedString("Incorrect email format", comment: "Incorrect email format")
        if email.isEmpty {
            failure?("\(errorMessage).")
        }
        else {
            failure?("\(errorMessage): \(email).")
        }
        return false
    }
    
    /// Check the order of the dates. End date must be after to equal to Start date.
    ///
    /// - Parameters:
    ///   - startDate: the start date
    ///   - endDate: the end date
    ///   - failure: the closure to invoke if validation fails
    /// - Returns: true - if the dates have correct order, false - else
    public class func validateStartAndEndDates(startDate: Date, endDate: Date,
                                               _ failure: FailureCallback?) -> Bool {
        if startDate.compare(endDate) == .orderedDescending {
            failure?("startDate should be equal or less than endDate")
            return false
        }
        return true
    }
}

/**
 * Extension that provides shortcut methods for ValidationUtils
 *
 * - author: Volkov Alexander
 * - version: 1.0
 */
extension String {
    
    /// Check if string is valid URL
    public var isValidURL: Bool {
        return ValidationUtils.validate(url: self, nil)
    }
    
    /// Check if string is valid ID
    public var isValidId: Bool {
        return ValidationUtils.validate(id: self, nil)
    }
    
    /// Check if string is valid (non-empty) string
    public var isValidString: Bool {
        return ValidationUtils.validateStringNotEmpty(self, nil)
    }
    
    /// Check if string is valid positive number
    public var isValidPositiveNumber: Bool {
        return ValidationUtils.validatePositiveNumber(self, nil)
    }
    
    /// Check if string is valid email
    public var isValidEmail: Bool {
        return ValidationUtils.validateEmail(self, nil)
    }
    
    /// Check if string is valid email. Alias for `isValidEmail`.
    public var isEmail: Bool { return isValidEmail }
    
    /// Check if string is valid ID (positive number). Alias for `isValidId`.
    public var isId: Bool { return isValidId }
}
