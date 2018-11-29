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
