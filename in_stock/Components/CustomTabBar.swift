import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab
    var addAction: () -> Void
    
    var body: some View {
        HStack {
            TabBarButton(icon: "house", tab: .home, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "square.grid.2x2", tab: .spaces, selectedTab: $selectedTab)
            Spacer()
            
            // Floating + Button
            Button(action: addAction) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.black)
                    .clipShape(Circle())
                    .shadow(color: AppTheme.shadowColor, radius: 10, x: 0, y: 5)
            }
            .offset(y: -20)
            
            Spacer()
            TabBarButton(icon: "list.bullet.clipboard", tab: .lists, selectedTab: $selectedTab)
            Spacer()
            TabBarButton(icon: "person", tab: .settings, selectedTab: $selectedTab)
        }
        .padding(.horizontal, 30)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .background(Color.white)
        .shadow(color: AppTheme.shadowColor, radius: 15, x: 0, y: -5)
    }
}

struct TabBarButton: View {
    let icon: String
    let tab: AppTab
    @Binding var selectedTab: AppTab
    
    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            Image(systemName: selectedTab == tab ? icon + ".fill" : icon)
                .font(.system(size: 24))
                .foregroundColor(selectedTab == tab ? .black : .gray)
        }
    }
}
