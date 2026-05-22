import SwiftUI

struct NotificationCard: View {
    let notification: NotificationItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: iconForType(notification.type))
                .font(.system(size: 20))
                .foregroundColor(AppTheme.primaryText)
                .frame(width: 40, height: 40)
                .background(Color(white: 0.95))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text("In Stock")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.secondaryText)
                
                Text(notification.title)
                    .font(AppTheme.bodyFont.bold())
                    .foregroundColor(AppTheme.primaryText)
                
                Text(notification.message)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Text(notification.timeText)
                .font(AppTheme.captionFont)
                .foregroundColor(AppTheme.secondaryText)
        }
        .cardStyle()
    }
    
    private func iconForType(_ type: ReminderType) -> String {
        switch type {
        case .lowStock: return "exclamationmark.circle"
        case .expiringSoon: return "clock"
        case .shoppingMode: return "cart"
        case .declutter: return "trash"
        case .push: return "bell"
        }
    }
}
