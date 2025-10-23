import Foundation

struct CoinModel: Codable, Identifiable {
    let symbol: String
    var price: String
    var id: String { symbol }
}

struct CryptoModel: Identifiable {
    var coin: CoinModel
    var isFavorite: Bool = false
    var id: String { coin.id }
}
