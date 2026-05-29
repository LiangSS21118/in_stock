import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        Group {
            if authViewModel.isLoggedIn {
                MainContainerView()
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                    .onAppear {
                        syncUser()
                    }
                    .onChange(of: authViewModel.currentUserName) { _ in
                        syncUser()
                    }
            } else {
                LoginView(viewModel: authViewModel)
                    .transition(.opacity.combined(with: .move(edge: .leading)))
            }
        }
        .animation(.spring(), value: authViewModel.isLoggedIn)
    }

    private func syncUser() {
        appViewModel.currentUser = User(
            name: authViewModel.currentUserName.isEmpty ? "使用者" : authViewModel.currentUserName,
            email: authViewModel.currentUserEmail,
            avatarName: "person.circle.fill"
        )
    }
}
