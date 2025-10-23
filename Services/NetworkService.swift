import Foundation
import SwiftUICore

protocol NetworkProtocol {
    func fetchCoin(id: String) async throws -> CoinModel
    func fetchAllUSDT() async throws -> [CoinModel]
}

final class NetworkService: NetworkProtocol {
    static let shared = NetworkService()
    private let logger: LoggerProtocol
    private let urlRequest = "https://api.binance.com/api/v3/ticker/price"
    
    private init(){
        logger = Logger.logger
        logger.log(message: "NetworkService started!", logLevel: .info)
    }
    
    func fetchCoin(id: String) async throws -> CoinModel {
        let url = URL(string: urlRequest + "?symbol=" + id)
        guard let url = url else {
            logger.log(message: "NetworkService. Inavalid URL", logLevel: .error)
            throw NetworkError.invalidURL
        }
        let (data, result) = try await URLSession.shared.data(from: url)
        logger.log(message: "NetworkService. Received data [Result: \(result), Data: \(String(decoding: data, as: UTF8.self))]", logLevel: .debug)
        
        if let res = result as? HTTPURLResponse {
            if res.statusCode != 200 {
                logger.log(message: "NetworkService. RequestFailed [Status code: \(res.statusCode)]", logLevel: .error)
                throw NetworkError.requestFailed
            }
            
            do {
                return try JSONDecoder().decode(CoinModel.self, from: data)
            } catch {
                logger.log(message: "NetworkService. DecodingFailed", logLevel: .error)
                throw NetworkError.decodingFailed
            }
        }
        logger.log(message: "NetworkService. RequestFailed", logLevel: .error)
        throw NetworkError.requestFailed
    }
    
    func fetchAllUSDT() async throws -> [CoinModel] {
        guard let url = URL(string: urlRequest) else {
            throw NetworkError.requestFailed
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw NetworkError.requestFailed
        }
        
        do {
            let all = try JSONDecoder().decode([CoinModel].self, from: data)
            return all.filter { $0.symbol.hasSuffix("USDT") }
        } catch {
            throw NetworkError.decodingFailed
        }
    }
    
}

struct NetworkServiceKey: EnvironmentKey {
    static let defaultValue: NetworkProtocol = NetworkService.shared
}

extension EnvironmentValues {
    var networkService: NetworkProtocol {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}
