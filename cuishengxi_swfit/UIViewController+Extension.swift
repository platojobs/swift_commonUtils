import UIKit
import MBProgressHUD
import SafariServices

// MARK: - Container

extension UIViewController {

  func addFullScreen(childViewController child: UIViewController) {
    guard child.parent == nil else {
      return
    }

    addChild(child)
    view.addSubview(child.view)

    child.view.translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
      view.topAnchor.constraint(equalTo: child.view.topAnchor),
      view.bottomAnchor.constraint(equalTo: child.view.bottomAnchor)
    ]
    constraints.forEach { $0.isActive = true }
    view.addConstraints(constraints)

    child.didMove(toParent: self)
  }

  func remove(childViewController child: UIViewController?) {
    guard let child = child else {
      return
    }

    guard child.parent != nil else {
      return
    }
    
    child.willMove(toParent: nil)
    child.view.removeFromSuperview()
    child.removeFromParent()
  }
}

// MARK: - Alert

extension UIViewController {
    
    func showAlert(title: String?, message: String, done: (() -> Void)? = nil) {
        showAlert(title: title, message: message, yesTitle: "OK", noTitle: nil, done: done)
    }
    
    func showAlert(title: String?,
                   message: String,
                   yesTitle: String?,
                   noTitle: String?,
                   done: (() -> Void)?) {
        showAlert(title: title, message: message, yesTitle: yesTitle, noTitle: noTitle, cancel: nil, done: done)
    }
    
    func showAlert(title: String?,
                   message: String,
                   yesTitle: String?,
                   noTitle: String?,
                   cancel: (() -> Void)?,
                   done: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let yesTitle = yesTitle {
            alert.addAction(UIAlertAction(title: yesTitle, style: .default, handler: { (_) in
                done?()
            }))
        }
        
        if let noTitle = noTitle {
            alert.addAction(UIAlertAction(title: noTitle, style: .cancel, handler: { (_) in
                cancel?()
            }))
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - MBProgressHUD

extension UIViewController {
    
    func showLoading(blockUI: Bool? = false) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.isUserInteractionEnabled = blockUI ?? false
    }
    
    func dismissLoading() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}

// MARK: - WebView

extension UIViewController {
    func showWeb(path: String, tint: UIColor? = nil) {
        guard let url = URL(string: path) else {
            return
        }
        
        showWeb(url: url, tint: tint)
    }
    
    func showWeb(url: URL, tint: UIColor? = nil) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = tint
        
        present(safariViewController, animated: true)
    }
}

// MARK: - StoryboardIdentifiable

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}

// MARK: - BackButton

extension UIViewController {
    
    func setBackTitleEmpty() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action:
            nil)
    }
    
    func hideBackButton() {
        navigationItem.hidesBackButton = true
    }
    
}
