import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var appViewModel = AppViewModel()

    var body: some View {
        RootView()
            .environmentObject(authViewModel)
            .environmentObject(appViewModel)
    }
}

#Preview {
    ContentView()
}
