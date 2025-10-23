import SwiftUI

struct MainView: View {
    @Environment(\.logger) var logger
    @Environment(\.networkService) var networkService
    
    @StateObject private var cvm = CryptoViewModel()
    @State private var text = String()
    @State private var selectedTab = 0
    @State private var currentDate = Date.now
    @State private var showingSheet = false
    @State private var isFirstLaunchApp = true
    private let timer = Timer.publish(every: 3, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
            VStack {
                // MARK: - Tabs
                HStack {
                    Button {
                        selectedTab = 0
                    } label: {
                        HStack {
                            Image(systemName: "bitcoinsign.bank.building")
                            Text("Market")
                        }
                    }
                    .buttonStyle(.tabButton)
                    .background(selectedTab == 0 ? .white : .gray)
                    .foregroundColor(selectedTab == 0 ? .white : .gray)

                    if Settings.isLoggedIn {
                        Button {
                            selectedTab = 1
                        } label: {
                            HStack {
                                Image(systemName: "star.fill")
                                Text("Favorites")
                            }
                        }
                        .buttonStyle(.tabButton)
                        .background(selectedTab == 1 ? .white : .gray)
                        .foregroundColor(selectedTab == 1 ? .white : .gray)
                    }

                    Spacer()

                    Button {
                        showingSheet.toggle()
                    } label: {
                        Image(systemName: "person.fill")
                    }
                    .popover(isPresented: $showingSheet) {
                        if Settings.isLoggedIn {
                            ProfileView()
                        } else {
                            AuthenticationView(isPresented: $showingSheet)
                        }
                    }
                }
                .padding()
                
                // MARK: - Coin List
                List {
                    if selectedTab == 0 {
                        ForEach($cvm.coins) { coin in
                            UpdatingPriceView(coin: coin)
                        }
                    } else {
                        ForEach(cvm.coins.indices.filter { cvm.coins[$0].isFavorite }, id: \.self) { index in
                            UpdatingPriceView(coin: $cvm.coins[index])
                        }
                    }
                }
                .task {
                    await cvm.loadAll()
                    if Settings.isLoggedIn && isFirstLaunchApp {
                        isFirstLaunchApp = false
                        await cvm.loadFavoritesForCurrentUser()
                    }
                }
                .refreshable {
                    await cvm.loadAll()
                }
                .onReceive(timer) { _ in
                    Task {
                        await cvm.loadAll()
                    }
                }
                .onChange(of: Settings.userName) { _ in
                    Task {
                        await cvm.loadFavoritesForCurrentUser()
                    }
                }
            }
        }
}
