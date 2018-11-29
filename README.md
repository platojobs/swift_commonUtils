# swift_commonUtils
swfit常用

```swift

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppConfig.hideBackButtonTitle {
            setBackTitleEmpty()
        }
        
        log.debug(self.className)
    }
    
    deinit {
        log.debug(self.className)
    }
    
}

class BaseTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppConfig.hideBackButtonTitle {
            setBackTitleEmpty()
        }
    }
    
    deinit {
        log.debug(self.className)
    }
}

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
```


```swift
//
//  ViewController.swift
//  cuishengxi
//
//  Created by cuishengxi on 29.11.2018.
//

import UIKit

class ViewController: UIViewController {

override func viewDidLoad() {
super.viewDidLoad()
// Do any additional setup after loading the view, typically from a nib.

validateData()
validateString()
validateInt()
}

func validateData() {

print("notemail".isValidEmail)
print("email@gmail.com".isValidEmail)

print("".isValidString)
print("string".isValidString)

print("abc".isValidPositiveNumber)
print("123".isValidPositiveNumber)
}

func validateString() {
print(" string ".trim()) // "string"
print("ABC".contains("BC")) // true
print("ABD".replace("D", withString: "C")) // ABC
print("http://some thing \"cool\"".urlEncodedString()) // "http%3A%2F%2Fsome%20thing%20%22cool%22"
print("domain.com/folder/something".lastPath()) // "something"
print("123456".substring(index: 1, length: 3)) // "234"
}

func validateInt() {
print(Int.random())
print(Int.random(10))
print(1000.toCurrency()) // 1,000
print(16.toHex()) // "10"
}
}


```
