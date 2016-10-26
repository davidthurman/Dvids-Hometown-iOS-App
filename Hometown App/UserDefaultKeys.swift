import Foundation

enum UserDefaultsKeys: String {
    
    case oauthAccessTokenExpiresAt
    case oauthRefreshTokenExpiresAt
    case oauthAccessToken
    case oauthRefreshToken
    case oauthMemberId
    case deviceToken
    
    var string: String? {
        return UserDefaults.standard.object(forKey:rawValue) as? String
    }
    
    
    var stringValue: String {
        return string ?? ""
    }
    
    
    var bool: Bool? {
        return UserDefaults.standard.object(forKey: rawValue) as? Bool
    }
    
    
    var boolValue: Bool {
        return bool ?? false
    }
    
    
    var int: Int? {
        return UserDefaults.standard.object(forKey: rawValue) as? Int
    }
    
    
    var intValue: Int {
        return int ?? 0
    }
    
    
    var double: Double? {
        return UserDefaults.standard.object(forKey: rawValue) as? Double
    }
    
    
    var date: Date? {
        return UserDefaults.standard.object(forKey: rawValue) as? Date
    }
    
    
    func dateGreaterThan(date: Date) -> Bool {
        if let storedDate = self.date, storedDate > date
        {
            return true
        }
        return false
    }
    
    
    func set(_ object: AnyObject?)
    {
        UserDefaults.standard.set(object, forKey: rawValue)
    }
    
    func set(_ object: String?)
    {
        UserDefaults.standard.set(object, forKey: rawValue)
    }
    
    func set(_ bool: Bool) {
        UserDefaults.standard.set(bool, forKey: rawValue)
    }
    
    
    func set(_ int: Int) {
        UserDefaults.standard.set(int, forKey: rawValue)
    }
    
    
    func remove() {
        UserDefaults.standard.removeObject(forKey: rawValue)
    }
    
}
