import Foundation

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    init(fileName: String, type: String = "json") {
        let fileLocation = Bundle.main.path(forResource: fileName, ofType: type)!
        self = try! String(contentsOfFile: fileLocation)
    }
    
    var isValidEmail: Bool {
        //http://emailregex.com/
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
