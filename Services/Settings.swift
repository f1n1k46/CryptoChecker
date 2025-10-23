import Foundation

final class Settings {
    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let userName = "loginName"
    }
    
    static var isLoggedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isLoggedIn)
        }
    }
    
    static var userName: String {
        get {
            UserDefaults.standard.string(forKey: Keys.userName) ?? "guest"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.userName)
        }
    }
}
