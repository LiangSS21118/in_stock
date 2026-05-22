import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                MainContainerView()
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            } else {
                LoginView(viewModel: authViewModel)
                    .transition(.opacity.combined(with: .move(edge: .leading)))
            }
        }
        .animation(.spring(), value: authViewModel.isLoggedIn)
    }
}
