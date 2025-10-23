import SwiftUI

struct ProfileView: View {
    @Environment(\.authService) var authService
    var body: some View {
        VStack {
            Text("Hello, \(Settings.userName)!")
            HStack {
                Button {
                    Settings.isLoggedIn = false
                    Settings.userName = ""
                } label: {
                    HStack {
                        Image(systemName: "door.left.hand.open")
                        Text("Exit")
                    }
                }
                .foregroundStyle(Color.red)
                .padding()
                
                Button {
                    Settings.isLoggedIn = false
                    FavoritesManager.deleteUserFavorites(for: Settings.userName)
                    authService.deleteFromKeychain(account: Settings.userName)
                    Settings.userName = ""
                } label: {
                    HStack {
                        Image(systemName: "minus.circle")
                        Text("Delete account")
                    }
                }
                .foregroundStyle(Color.red)
                .padding()
            }
        }
    }
}
