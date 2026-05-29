import SwiftUI

struct MainContainerView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content
            Group {
                switch appViewModel.selectedTab {
                case .home:
                    DashboardView(viewModel: appViewModel)
                case .spaces:
                    SpaceView(viewModel: appViewModel)
                case .add:
                    AddItemEntryView(appViewModel: appViewModel)
                case .lists:
                    ListView(viewModel: appViewModel)
                case .settings:
                    ProfileView(authViewModel: authViewModel, appViewModel: appViewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 60) // Space for TabBar
            
            // Fixed Bottom Tab Bar
            CustomTabBar(selectedTab: $appViewModel.selectedTab) {
                appViewModel.startAddingItem()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(AppTheme.backgroundColor)
    }
}
