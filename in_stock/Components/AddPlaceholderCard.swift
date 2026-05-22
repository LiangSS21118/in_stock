import SwiftUI

struct AddPlaceholderCard: View {
    let text: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppTheme.secondaryText)
            
            Text(text)
                .font(AppTheme.bodyFont.bold())
                .foregroundColor(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 30)
        .background(AppTheme.cardBackgroundColor)
        .cornerRadius(AppTheme.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                .foregroundColor(AppTheme.borderColor)
        )
    }
}
