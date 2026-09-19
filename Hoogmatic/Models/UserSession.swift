import Foundation

public class UserSession {
    public static let shared = UserSession()
    
    private let defaults = UserDefaults.standard
    
    private let keyApiToken = "api_token"
    private let keyUserId = "user_id"
    private let keyUserName = "user_name"
    private let keyUserEmail = "user_email"
    private let keyUserMobile = "user_mobile"
    
    private init() {}
    
    public var apiToken: String {
        get { return defaults.string(forKey: keyApiToken) ?? "" }
        set { defaults.set(newValue, forKey: keyApiToken) }
    }
    
    public var userId: Int {
        get { return defaults.integer(forKey: keyUserId) }
        set { defaults.set(newValue, forKey: keyUserId) }
    }
    
    public var userName: String {
        get { return defaults.string(forKey: keyUserName) ?? "" }
        set { defaults.set(newValue, forKey: keyUserName) }
    }
    
    public var userEmail: String {
        get { return defaults.string(forKey: keyUserEmail) ?? "" }
        set { defaults.set(newValue, forKey: keyUserEmail) }
    }
    
    public var userMobile: String {
        get { return defaults.string(forKey: keyUserMobile) ?? "" }
        set { defaults.set(newValue, forKey: keyUserMobile) }
    }
    
    public var isLoggedIn: Bool {
        return !apiToken.isEmpty && userId > 0
    }
    
    public func clearSession() {
        defaults.removeObject(forKey: keyApiToken)
        defaults.removeObject(forKey: keyUserId)
        defaults.removeObject(forKey: keyUserName)
        defaults.removeObject(forKey: keyUserEmail)
        defaults.removeObject(forKey: keyUserMobile)
    }
}
