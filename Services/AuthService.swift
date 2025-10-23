import Foundation
import Security
import SwiftUICore

protocol AuthProtocol {
    func saveToKeychain(account: String, token: String) -> Bool
    func readFromKeychain(account: String) -> String?
    func deleteFromKeychain(account: String)
}

final class AuthService: AuthProtocol {
    static let shared = AuthService()
    private let logger: LoggerProtocol
    
    private init(){
        logger = Logger.logger
        logger.log(message: "AuthService started!", logLevel: .info)
    }
    
    // MARK: - Save
    func saveToKeychain(account: String, token: String) -> Bool {
        guard let data = token.data(using: .utf8) else {
            logger.log(message: "Failed to encode token for account: \(account)", logLevel: .error)
            return false
        }
        
        let query: [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account,
            kSecAttrService as String : Constants.serviceName,
            kSecAttrLabel as String: Constants.serviceName,
            kSecValueData as String : data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            logger.log(message: "Token successfully saved to Keychain for account: \(account)", logLevel: .info)
            return true
        } else {
            logger.log(message: "Failed to save token to Keychain for account: \(account). Status code: \(status)", logLevel: .error)
            return false
        }
    }
    
    // MARK: - Read
    func readFromKeychain(account: String) -> String? {
        let query: [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account,
            kSecAttrService as String : Constants.serviceName,
            kSecReturnData as String : true,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            logger.log(message: "Successfully read token from Keychain for account: \(account)", logLevel: .info)
            return String(data:data, encoding: .utf8)
        }
        logger.log(message: "No token found in Keychain for account: \(account). Status code: \(status)", logLevel: .error)
        return nil
    }
    
    // MARK: - Delete
    func deleteFromKeychain(account: String) {
        let query: [String : Any] = [
            kSecClass as String : kSecClassGenericPassword,
            kSecAttrAccount as String : account,
            kSecAttrService as String : Constants.serviceName
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            logger.log(message: "Token successfully deleted from Keychain for account: \(account)", logLevel: .info)
        } else {
            logger.log(message: "No token to delete in Keychain for account: \(account). Status code: \(status)", logLevel: .error)
        }
    }
}

struct AuthServiceKey: EnvironmentKey {
    static let defaultValue: AuthProtocol = AuthService.shared
}

extension EnvironmentValues {
    var authService: AuthProtocol {
        get { self[AuthServiceKey.self] }
        set { self[AuthServiceKey.self] = newValue }
    }
}
