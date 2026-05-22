import SwiftUI

struct StatCard: View {
    let iconName: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 24))
                .foregroundColor(AppTheme.primaryText)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondaryText)
                
                Text(value)
                    .font(AppTheme.headerFont)
                    .foregroundColor(AppTheme.primaryText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}
