import SwiftUI

struct ReminderCenterView: View {
    let notifications: [NotificationItem]
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(notifications) { notification in
                NotificationCard(notification: notification)
            }
            
            // Notification Description Footer
            VStack(alignment: .leading, spacing: 12) {
                ReminderInfoRow(title: "低庫存提醒", description: "物品低於門檻時自動通知")
                ReminderInfoRow(title: "即將到期提醒", description: "物品到期前 2-7 天主動通知")
                ReminderInfoRow(title: "購物模式切換", description: "採買時一鍵開啟購物清單")
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white.opacity(0.5))
            .cornerRadius(AppTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.borderColor, lineWidth: 1)
            )
        }
    }
}

struct ReminderInfoRow: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.black)
                .frame(width: 4, height: 4)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppTheme.captionFont.bold())
                Text(description)
                    .font(.system(size: 10))
                    .foregroundColor(AppTheme.secondaryText)
            }
        }
    }
}
