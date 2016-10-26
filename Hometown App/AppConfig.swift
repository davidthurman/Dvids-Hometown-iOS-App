import UIKit

struct AppConfig {
    
    static let dvidsApiPublicKey = "key-57e0326f67084"
    
    static let dvidsApiSecretKey = "7e168d7d7c73ae4564ce2255e0922c1dd98c5857"
    
    static let tintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    
    static let defaultTVCellSelectedColor = #colorLiteral(red: 0.231372549, green: 0.231372549, blue: 0.231372549, alpha: 1)
    
    static let defaultTVCellSelectedView: UIView = {
        let v = UIView()
        v.backgroundColor = defaultTVCellSelectedColor
        return v
    }()
    
}
