import SwiftUI

struct CustomTabBar: View {
    let selectedTab: AppTab
    var selectTab: (AppTab) -> Void
    var addAction: () -> Void
    
    var body: some View {
        HStack {
            TabBarButton(icon: "house", isSelected: selectedTab == .home) {
                selectTab(.home)
            }
            Spacer()
            TabBarButton(icon: "square.grid.2x2", isSelected: selectedTab == .spaces) {
                selectTab(.spaces)
            }
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
            TabBarButton(icon: "list.bullet.clipboard", isSelected: selectedTab == .lists) {
                selectTab(.lists)
            }
            Spacer()
            TabBarButton(icon: "person", isSelected: selectedTab == .settings) {
                selectTab(.settings)
            }
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
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? icon + ".fill" : icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? .black : .gray)
        }
    }
}
