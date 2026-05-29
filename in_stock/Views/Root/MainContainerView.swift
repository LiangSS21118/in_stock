import SwiftUI

struct MainContainerView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var pendingShoppingExitTab: AppTab?
    @State private var isShowingShoppingExitAlert = false
    
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
            .padding(.bottom, 90) // Increased space for TabBar and sticky buttons
            
            // Fixed Bottom Tab Bar
            CustomTabBar(
                selectedTab: appViewModel.selectedTab,
                selectTab: selectTab,
                addAction: startAddingItem
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(AppTheme.backgroundColor)
        .alert("購物尚未完成，要暫離嗎？", isPresented: $isShowingShoppingExitAlert) {
            Button("繼續購物", role: .cancel) {
                pendingShoppingExitTab = nil
            }
            Button("暫離") {
                leaveShoppingModeTemporarily()
            }
        } message: {
            Text("購物清單會保留目前狀態，你可以稍後再回來完成。")
        }
    }

    private func selectTab(_ tab: AppTab) {
        guard shouldConfirmLeavingShopping(for: tab) else {
            appViewModel.selectedTab = tab
            return
        }

        pendingShoppingExitTab = tab
        isShowingShoppingExitAlert = true
    }

    private func startAddingItem() {
        guard shouldConfirmLeavingShopping(for: .add) else {
            appViewModel.startAddingItem()
            return
        }

        pendingShoppingExitTab = .add
        isShowingShoppingExitAlert = true
    }

    private func shouldConfirmLeavingShopping(for tab: AppTab) -> Bool {
        appViewModel.isShoppingFocusActive && appViewModel.selectedTab == .lists && tab != .lists
    }

    private func leaveShoppingModeTemporarily() {
        let destination = pendingShoppingExitTab
        pendingShoppingExitTab = nil
        appViewModel.pauseShoppingMode()

        if destination == .add {
            appViewModel.startAddingItem()
        } else if let destination {
            appViewModel.selectedTab = destination
        }
    }
}
