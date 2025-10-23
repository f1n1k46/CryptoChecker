import SwiftUI
import Combine

struct UpdatingPriceView: View {
    @State private var highlightColor: Color = .black
    @State private var lastPrice: Double = 0
    @State private var addedToFavorite = false
    @Binding var coin: CryptoModel

    let upvm = UpdatingPriceViewModel()

    var body: some View {
        HStack {
            if Settings.isLoggedIn {
                Button {
                    coin.isFavorite.toggle()
                    FavoritesManager.toggleFavorite(for: coin.coin.id, user: Settings.userName)
                } label: {
                    Image(systemName: coin.isFavorite ? "star.fill" : "star")
                }
            }
            
            Text(coin.coin.symbol)
            Spacer()
            Text(coin.coin.price)
                .foregroundStyle(highlightColor.gradient)
                .font(.headline)
        }
        .onChange(of: coin.coin.price, perform: { newValue in
            let newPrice = (newValue as NSString).doubleValue
            
            if lastPrice == 0 {
                lastPrice = newPrice
                return
            }
            
            if newPrice > lastPrice {
                highlightColor = .green
            } else if newPrice < lastPrice {
                highlightColor = .red
            }
                        
            lastPrice = newPrice
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeOut(duration: 1)) {
                    highlightColor = .black
                }
            }
        })
    }
}
