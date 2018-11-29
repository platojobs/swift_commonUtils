import Foundation

extension Array where Element: Equatable {
    
    mutating func remove(object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func replaceFirst(object: Element) {
        if let index = self.index(of: object) {
            self[index] = object
        }
    }
    
    mutating func replace<C : Collection>(newElements: C) where C.Iterator.Element == Element {
        newElements.forEach {
            if self.contains($0) {
                self.replaceFirst(object: $0)
            } else {
                self.append($0)
            }
        }
    }
    
    mutating func merge<C : Collection>(newElements: C) where C.Iterator.Element == Element{
        let filteredList = newElements.filter({!self.contains($0)})
        self.append(contentsOf: filteredList)
    }
}

extension Array {
    init(plist: String) {
        self = NSArray(contentsOfFile: Bundle.main.path(forResource: plist, ofType: "plist")!) as! Array<Element>
    }
}
