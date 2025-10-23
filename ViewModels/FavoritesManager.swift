import Foundation

final class FavoritesManager {
    static let key = "favorites_per_user"
    
    static func getFavorites(for user: String) -> [String] {
        guard let data = UserDefaults.standard.dictionary(forKey: key) as? [String: [String]] else {
            return []
        }
        return data[user] ?? []
    }
    
    static func saveFavorites(_ favorites: [String], for user: String) {
        var data = UserDefaults.standard.dictionary(forKey: key) as? [String: [String]] ?? [:]
        data[user] = favorites
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func toggleFavorite(for coinId: String, user: String) {
        var favorites = getFavorites(for: user)
        if favorites.contains(coinId) {
            favorites.removeAll { $0 == coinId }
        } else {
            favorites.append(coinId)
        }
        saveFavorites(favorites, for: user)
    }
    
    static func deleteUserFavorites(for user: String) {
        var data = UserDefaults.standard.dictionary(forKey: key) as? [String: [String]] ?? [:]
        data.removeValue(forKey: user)
        UserDefaults.standard.set(data, forKey: key)
    }
}
