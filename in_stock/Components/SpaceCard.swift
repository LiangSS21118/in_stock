import SwiftUI

struct SpaceCard: View {
    let space: Space
    
    var body: some View {
        VStack(spacing: 12) {
            Text(space.asciiArtText)
                .font(.system(size: 10, weight: .regular, design: .monospaced))
                .foregroundColor(AppTheme.primaryText)
                .multilineTextAlignment(.center)
                .lineLimit(6)
                .frame(height: 80)
            
            Text(space.name)
                .font(AppTheme.bodyFont.bold())
                .foregroundColor(AppTheme.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppTheme.cardBackgroundColor)
        .cornerRadius(AppTheme.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
        )
    }
}
