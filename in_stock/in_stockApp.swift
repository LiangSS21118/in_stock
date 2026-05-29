import SwiftUI

@main
struct InStockApp: App {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(appViewModel)
        }
    }
}
