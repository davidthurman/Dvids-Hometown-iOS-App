import UIKit

final class Utility {
    
    static func presentOkAlert(onViewController viewController: UIViewController, withMessage message: String?, title: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
