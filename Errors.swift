import Foundation

enum CryptoCheckerErrors: Error {
    
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
}
