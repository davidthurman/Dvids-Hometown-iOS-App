import UIKit
import SafariServices

extension UIViewController {
    
    public func presentOkAlert(withMessage message: String?, title: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        Utility.presentOkAlert(onViewController: self, withMessage: message, title: title, handler: handler)
    }
    
    public func presentSafariViewController(url: URL) {
        let sfController = SFSafariViewController(url: url)
        sfController.delegate = self
        if #available(iOS 10.0, *) {
            sfController.preferredBarTintColor = UIColor.black
            sfController.preferredControlTintColor = AppConfig.tintColor
        } else {
            UIApplication.shared.statusBarStyle = .default
            sfController.view.tintColor = AppConfig.tintColor
        }
        present(sfController, animated: true, completion: nil)
    }
    
}

extension UIViewController: SFSafariViewControllerDelegate {
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        if #available(iOS 10.0, *) { } else {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
}
