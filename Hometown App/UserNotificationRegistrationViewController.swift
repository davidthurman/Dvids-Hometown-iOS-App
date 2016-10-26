import UIKit

final class UserNotificationRegistrationViewController: UIViewController {
    
    @IBAction func continueAction() {
        //AppDelegate.registerForPushNotifications()
        NotificationNames.notificationsSetupCompleted.add(observer: self, selector: #selector(onNotificationsSetupCompleted))
    }
    
    
    func onNotificationsSetupCompleted() {
        //navigationController?.viewControllers = [UIStoryboard.main.instantiateViewController(withIdentifier: AlertsTableViewController.nameOfClass)]
    }
    
    
    deinit {
        NotificationNames.notificationsSetupCompleted.remove(observer: self)
    }
    
}
