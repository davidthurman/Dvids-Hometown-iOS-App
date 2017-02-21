import UIKit

struct AppConfig {
    
    static let dvidsApiPublicKey = "key-58a361f745cf7"
    
    static let dvidsApiSecretKey = "0dfeb29c94a4d72a7fff137c501c1af7ad84783c"
    
    static let tintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    
    static let defaultTVCellSelectedColor = #colorLiteral(red: 0.231372549, green: 0.231372549, blue: 0.231372549, alpha: 1)
    
    static let defaultTVCellSelectedView: UIView = {
        let v = UIView()
        v.backgroundColor = defaultTVCellSelectedColor
        return v
    }()
    
}
