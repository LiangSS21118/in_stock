import SwiftUI

struct ReminderCenterView: View {
    let notifications: [NotificationItem]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if notifications.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "bell.slash")
                            .font(.system(size: 48))
                            .foregroundColor(AppTheme.secondaryText.opacity(0.5))
                        Text("目前沒有新的提醒")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    .padding(.top, 60)
                } else {
                    ForEach(notifications) { notification in
                        NotificationCard(notification: notification)
                    }
                }
            }
            .padding(.vertical)
        }
    }
}
