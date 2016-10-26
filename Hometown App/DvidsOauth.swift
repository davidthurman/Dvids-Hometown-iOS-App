import Foundation

final class DvidsOauth {
    
    static let redirectUri = "https://www.dvidshub.net/redirect/dvidsalertsoauth"
    
    
    static let authorizeUrl: URL = {
        var urlComponents = URLComponents(string: "https://api.dvidshub.net/auth/authorize")
        urlComponents!.queryItems = [
            URLQueryItem(name: "client_id", value: AppConfig.dvidsApiPublicKey),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "basic email alerts")
        ]
        return urlComponents!.url!
    }()
    
    
    static let accessTokenUrl = URL(string: "https://api.dvidshub.net/auth/access_token")!
    
    
    static let getInfoUrl = URL(string: "https://api.dvidshub.net/auth/get-info")!
    
    
    static func getAccessToken(withCode code: String, callback: @escaping (_ success: Bool) -> ()) {
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "client_id", value: AppConfig.dvidsApiPublicKey),
            URLQueryItem(name: "client_secret", value: AppConfig.dvidsApiSecretKey),
            URLQueryItem(name: "api_key", value: AppConfig.dvidsApiSecretKey),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "redirect_uri", value: redirectUri)
        ]
        
        let postData = urlComponents.percentEncodedQuery!.data(using: String.Encoding.utf8)!
        _getAccessToken(postData: postData, callback: callback)
    }
    
    
    static func getAccessToken(callback: @escaping (_ success: Bool) -> ()) {
        guard let refreshToken = UserDefaultsKeys.oauthRefreshToken.string else { return callback(false) }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = [
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "client_id", value: AppConfig.dvidsApiPublicKey),
            URLQueryItem(name: "client_secret", value: AppConfig.dvidsApiSecretKey),
            URLQueryItem(name: "api_key", value: AppConfig.dvidsApiSecretKey),
            URLQueryItem(name: "grant_type", value: "refresh_token")
        ]
        
        let postData = urlComponents.percentEncodedQuery!.data(using: String.Encoding.utf8)!
        _getAccessToken(postData: postData, callback: callback)
    }
    
    
    private static func _getAccessToken(postData: Data, callback: @escaping (_ success: Bool) -> ()) {
        var request = URLRequest(url: accessTokenUrl)
        request.httpMethod = "POST"
        request.setValue(String(postData.count), forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return callback(false) }
            let json = JSON(data: data)
            logger.debug(json.description)
            guard let expiresIn = json["expires_in"].double, let accessToken = json["access_token"].string, let refreshToken = json["refresh_token"].string
                else { return callback(false) }
            
            UserDefaultsKeys.oauthAccessTokenExpiresAt.set(NSDate(timeIntervalSinceNow: expiresIn - 900))
            if let refreshTokenExpiresAtString = json["refresh_token_expires_at"].string, let refreshTokenExpiresAt = Date.dateFromISOString(string: refreshTokenExpiresAtString)  {
                var offset = DateComponents()
                offset.minute = -15
                
                if let offsetExpiresAt = Calendar(identifier: .gregorian).date(byAdding: offset, to: refreshTokenExpiresAt) {
                    UserDefaultsKeys.oauthRefreshTokenExpiresAt.set(offsetExpiresAt as NSDate)
                }
                
            }
            UserDefaultsKeys.oauthAccessToken.set(accessToken)
            UserDefaultsKeys.oauthRefreshToken.set(refreshToken)
            return callback(true)
        }
        task.resume()
    }
    
    
    // Checks if we have a valid access token. If not it tries to get one using the refresh token and responds whether it was successful or not
    static func hasValidAccessToken(callback: ((_ success: Bool) -> ())?) -> Bool {
        guard UserDefaultsKeys.oauthAccessTokenExpiresAt.dateGreaterThan(date: Date()) else {
            getAccessToken() { (success) in
                callback?(success)
            }
            logger.debug("Had expired access token")
            return false
        }
        logger.debug("Had nonexpired access token")
        return true
    }
    
    
    static func getMemberId(callback: @escaping (_ success: Bool) -> ()) {
        let hasValidAccessToken = DvidsOauth.hasValidAccessToken() {
            (success) in
            if success {
                getMemberId(callback: callback)
            } else {
                callback(false)
            }
        }
        guard hasValidAccessToken else { return }
        
        var urlComponents = URLComponents(url: getInfoUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: UserDefaultsKeys.oauthAccessToken.stringValue),
            URLQueryItem(name: "api_key", value: AppConfig.dvidsApiSecretKey)
        ]
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlComponents.url!) { (data, response, error) in
            guard let data = data else {
                UserDefaultsKeys.oauthMemberId.remove()
                return callback(false)
            }
            
            let json = JSON(data: data)
            logger.debug(json.description)
            guard let memberId = json["owner_id"].string else {
                UserDefaultsKeys.oauthMemberId.remove()
                return callback(false)
            }
            UserDefaultsKeys.oauthMemberId.set(memberId)
            callback(true)
        }
        task.resume()
    }
    
    
    static func clearOutOAuthInfo() {
        UserDefaultsKeys.oauthAccessToken.remove()
        UserDefaultsKeys.oauthRefreshToken.remove()
        UserDefaultsKeys.oauthAccessTokenExpiresAt.remove()
        UserDefaultsKeys.oauthRefreshTokenExpiresAt.remove()
    }
    
}
