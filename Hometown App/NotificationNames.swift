import Foundation

enum NotificationNames: String {
    
    case appOpenedWithUrl
    case notificationsSetupCompleted
    
    
    func postNotification(object: AnyObject?, userInfo: [NSObject : AnyObject]? = nil){
        NotificationCenter.default.post(name: Notification.Name(rawValue), object: object, userInfo: userInfo)
    }
    
    
    func add(observer: AnyObject, selector: Selector, object: AnyObject? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue), object: object)
    }
    
    
    func remove(observer: AnyObject, object: AnyObject? = nil) {
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue), object: object)
    }
    
}
