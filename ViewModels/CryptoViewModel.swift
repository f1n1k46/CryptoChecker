import Foundation

@MainActor
final class CryptoViewModel: ObservableObject {
    @Published var coins: [CryptoModel] = []
    private let network: NetworkProtocol
    private let logger: LoggerProtocol
    
    init(network: NetworkProtocol = NetworkService.shared) {
        self.network = network
        self.logger = Logger.logger
    }
    
    func loadAll() async {
        do {
            let res = try await network.fetchAllUSDT()
            await updateCoins(with: res)
        } catch {
            logger.log(message: "Failed to load coins. Error: \(error.localizedDescription)", logLevel: .error)
        }
    }
    
    private func fillModel(coinsModel: [CoinModel]) async -> [CryptoModel] {
        var cryptoModels: [CryptoModel] = []
        for coin in coinsModel {
            let cryptoModel = CryptoModel(coin: coin)
            cryptoModels.append(cryptoModel)
        }
        return cryptoModels
    }
    
    private func updateCoins(with newData: [CoinModel]) async {
        for newCoin in newData {
            if let index = coins.firstIndex(where: { $0.coin.id == newCoin.id }) {
                coins[index].coin.price = newCoin.price
            } else {
                let newModel = CryptoModel(coin: newCoin)
                coins.append(newModel)
            }
        }
    }
    
    func loadFavoritesForCurrentUser() async {
        let user = Settings.userName
        let favorites = FavoritesManager.getFavorites(for: user)
        for i in 0..<coins.count {
            coins[i].isFavorite = favorites.contains(coins[i].coin.id)
        }
    }

    var favoriteCoins: [CryptoModel] {
        coins.filter { $0.isFavorite }
    }
}
