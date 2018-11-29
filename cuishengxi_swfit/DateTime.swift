import Foundation
import ObjectMapper
import SwiftDate

struct DateTime {
    static let region = Region(calendar: Calendars.iso8601, zone: Zones.asiaTokyo, locale: Locales.japaneseJapan)
    static let parseFormats: [String] = [
        "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd HH:mm:ss Z",
        "yyyy-MM-dd",
        "yyyyMMdd",
        "yyyy年M月"
    ]
    
    static func setupRegion() {
        SwiftDate.defaultRegion = region
    }
    
    static func parse(_ string: String?) -> Date? {
        return string?.toDate(parseFormats, region: region)?.date
    }
}

struct DateTransform: TransformType {
    typealias Object = Date
    typealias JSON = String
    
    let format: String
    
    init(format: String) {
        self.format = format
    }
    
    init() {
        self.init(format: "yyyy-MM-dd'T'HH:mm:ssXXX")
    }
        
    func transformFromJSON(_ value: Any?) -> Object? {
        if let string = value as? String {
            return DateTime.parse(string)
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
//         DateToStringStyles.custom(format).toString(dt)
        return value?.toString(.custom(format))
    }
}
