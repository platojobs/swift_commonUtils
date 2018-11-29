//
//  CSXNumberEx.swift
//  cuishengxi
//
//  Created by 崔盛希 on 2018/11/29.
//

import Foundation

/**
 * Extenstion adds helpful methods to Int
 *
 * - author: cuishengxi
 * - version: 1.0
 */
extension Int {
    
    /// Get uniform random value between 0 and maxValue
    ///
    /// - Parameter maxValue: the limit of the random values
    /// - Returns: random Int
    public static func random(_ maxValue: Int = 1000000) -> Int {
        #if os(Linux)
        return Int(random() % maxValue)
        #else
        return Int(arc4random_uniform(UInt32(maxValue)))
        #endif
    }
    
    /// Returns string to show as a currency, e.g. 1230 -> "1,230"
    ///
    /// - Returns: string
    func toCurrency() -> String {
        return String.localizedStringWithFormat("%d", self) as String
    }
    
    /// Round interger (like bytes) to Gb, Mb or Kb, e.g. 1000 -> "1 Kb"
    ///
    /// - Returns: the string
    func toMb() -> String {
        if self >= 1000000000 {
            return (Float(self/100000000)/10).toCurrency() + " Gb"
        }
        else if self >= 1000000 {
            return (Float(self/100000)/10).toCurrency() + " Mb"
        }
        else if self >= 1000 {
            return (Float(self/100)/10).toCurrency() + " Kb"
        }
        else {
            return "\(self) b"
        }
    }
    
    /// Convert to hex string, e.g. 16 -> "10"
    ///
    /// - Returns: hex string
    func toHex() -> String {
        return String(format: "%02hhx", self)
    }
}

/**
 * Extenstion adds helpful methods to Float
 *
 * - author: Alexander Volkov
 * - version: 1.0
 */
extension Float {
    
    /// Format as string
    ///
    /// - Returns: string
    func toString() -> String {
        return String.localizedStringWithFormat("%.1f", self) as String
    }
    
    /// Format as currency string
    ///
    /// - Returns: string
    func toCurrency() -> String {
        if self.isInteger() {
            return String.localizedStringWithFormat("%.f", rounded()) as String
        }
        else {
            return String.localizedStringWithFormat("%.2f", self) as String
        }
    }
    
    /// Get uniform random value between 0 and maxValue
    ///
    /// - Parameter maxValue: the limit of the random values
    /// - Returns: random Float
    static func random(_ maxValue: UInt32 = 1) -> Float {
        let floating: UInt32 = 100
        #if os(Linux)
        return random().truncatingRemainder(dividingBy: Float(maxValue * floating)) / Float(floating)
        #else
        return Float(arc4random_uniform(maxValue * floating)) / Float(floating)
        #endif
    }
    
    /// Get uniform random value between 0 and maxValue and randomly use integer or float value
    ///
    /// - Parameter maxValue: the limit of the random values
    /// - Returns: random Float
    static func randomForDemo(maxValue: UInt32) -> Float {
        return Int.random(2) > 0 ? Float.random(10) : Float(Int.random(10))
    }
    
    /// Check if the value is integer
    ///
    /// - Returns: true - if integer value, false - else
    func isInteger() -> Bool {
        if self > Float(Int.max)
            || self < Float(Int.min) {
            print("ERROR: the value can not be converted to Int because it is greater/smaller than Int.max/min")
            return false
        }
        return  self == Float(Int(self))
    }
    
    /// Returns string to show as a currency.
    /// For dollar values, all stats that are less than $1 should be rounded to the nearest 10 cents.
    /// Examples: 1.23 -> "1", "0.53" -> "0.5", "0.98" -> "1.0", "4.0 -> "4"
    ///
    /// - Returns: string
    func roundCurrency() -> String {
        if self >= 1  || self == 0 {
            return String.localizedStringWithFormat("%.f", self.rounded()) as String
        }
        else {
            let value = Float(self * 10).rounded() / 10
            return String.localizedStringWithFormat("%.1f", value) as String
        }
    }
    
    /// Rounds the value according to the rules:
    /// Rounding should always be done to the nearest whole number unless the numbers is less than 1.
    /// If it’s larger than .05 then round to the tenth.
    /// If it’s smaller than .05 but larger than .005 then round to the hundredth.
    /// If it’s smaller than .005, then it should be zero.
    ///
    /// - Returns: string representation of the rounded value
    func roundSmart() -> String {
        if self >= 1 {
            return String.localizedStringWithFormat("%.f", self.rounded()) as String
        }
        else if self > 0.05 {
            let v: Float = self * 10
            let value = v.rounded() / 10
            return String.localizedStringWithFormat("%.1f", value) as String
        }
        else if self > 0.005 {
            let v: Float = self * 100
            let value = v.rounded() / 100
            return String.localizedStringWithFormat("%.2f", value) as String
        }
        else {
            return "0"
        }
    }
    
    /// Rounds down the value to quarter.
    /// Examples: 12.03->12, 3.46->3.25, 0.77->0.75
    ///
    /// - Returns: the rounded value
    func floorQuarter() -> Float {
        if isInteger() {
            return self
        }
        else {
            return floor(self * 4) / 4
        }
    }
    
    /// Rounds down the value to quarter.
    /// Examples: 12.03->"12", 3.46->"3.25", 0.77->"0.75"
    ///
    /// - Returns: string representation of the rounded value
    func quarterString() -> String {
        let value = floorQuarter()
        if value.isInteger() {
            return String.localizedStringWithFormat("%.f", self.rounded()) as String
        }
        else if value.truncatingRemainder(dividingBy: floor(value)) == 0.5 {
            return String.localizedStringWithFormat("%.1f", value) as String
        }
        else {
            return String.localizedStringWithFormat("%.2f", value) as String
        }
    }
    
    /// Rounds the value using next rules:
    /// 0.002 -> 0 // < 0.005
    /// 0.034 -> 0.034 // < 0.05
    /// 0.056 -> 0.6 // < 1
    /// 7.8 -> 8 // < 1000
    /// 1000 -> 0.1K // 1 < x < 1000000
    /// 100000000 -> 100M // > 1000000
    ///
    /// - Returns: string representation of the rounded value
    func roundLetter() -> String {
        if self < 1000 {
            return roundSmart()
        }
        else if self < 1000000 { // *K
            let value = self/1000
            return value.roundSmart() + "K"
        }
        else if self < 1000000000 { // *M
            let value = self/1000000
            return value.roundSmart() + "M"
        }
        else { // *G
            let value = self/1000000000
            return value.roundSmart() + "G"
        }
    }
    
    /// Does the same as roundLetter but returns digits and letters separatly.
    /// Used for rounding dollars on map markers.
    /// "G" for values grader than 1000000000 is replaced with "B"
    ///
    ///
    /// - Returns: tuple: (digits, letters), e.g. (100, "k"), (3, "M"), (450, "B")
    func roundLetterSeparatedDollar() -> (String, String) {
        // using currencyString because it's dollar rounding
        if self < 1000 {
            return (self.roundCurrency(), "")
        }
        else if self < 1000000 { // *k
            let value = self/1000
            return (value.roundSmart(), "k")
        }
        else if self < 1000000000 { // *M
            let value = self/1000000
            return (value.roundSmart(), "M")
        }
        else { // *G
            let value = self/1000000000
            return (value.roundSmart(), "B")
        }
    }
}
