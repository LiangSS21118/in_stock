import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Header
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Hi, \(authViewModel.currentUserName)")
                            .font(AppTheme.titleFont)
                        Text(authViewModel.currentUserEmail)
                            .font(AppTheme.captionFont)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // Settings List
                VStack(spacing: 0) {
                    SettingsRow(icon: "person.fill", title: "個人資料")
                    Divider().padding(.leading, 56)
                    SettingsRow(icon: "gearshape.fill", title: "設定")
                    Divider().padding(.leading, 56)
                    Button(action: { authViewModel.logout() }) {
                        SettingsRow(icon: "rectangle.portrait.and.arrow.right", title: "登出", color: .red)
                    }
                }
                .background(Color.white)
                .cornerRadius(AppTheme.cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.borderColor, lineWidth: 1))
                .padding(.horizontal)
                
                // Achievements
                AchievementView(achievements: appViewModel.achievements)
                    .padding(.horizontal)
                
                Spacer(minLength: 100)
            }
            .padding(.top, 20)
        }
        .background(AppTheme.backgroundColor)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var color: Color = .black
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)
            
            Text(title)
                .font(AppTheme.bodyFont.bold())
                .foregroundColor(color)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding()
    }
}
