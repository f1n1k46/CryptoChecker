import SwiftUI

@main
struct CrypoCheckerApp: App {
    
    let logger: LoggerProtocol = Logger.logger
    let networkService: NetworkProtocol = NetworkService.shared
    let authService: AuthService = AuthService.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.logger, logger)
                .environment(\.networkService, networkService)
                .environment(\.authService, authService)
        }
    }
}
