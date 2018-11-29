import UIKit

protocol ViewControllerChanger: class {
    func changeTo(viewController: UIViewController)
}

extension ViewControllerChanger where Self: UIViewController {
    func changeTo(viewController: UIViewController) {
        viewController.modalTransitionStyle = .crossDissolve
        
        present(viewController, animated: true, completion: nil)
    }
}

