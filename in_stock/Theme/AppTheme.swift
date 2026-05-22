import SwiftUI

struct AppTheme {
    // Colors
    static let backgroundColor = Color(white: 0.98) // 米白色背景
    static let cardBackgroundColor = Color.white
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let accentColor = Color.black
    static let borderColor = Color(white: 0.9)
    
    // Status Colors (Soft)
    static let lowStockBg = Color.orange.opacity(0.1)
    static let lowStockText = Color.orange
    static let expiringSoonBg = Color.red.opacity(0.1)
    static let expiringSoonText = Color.red
    static let normalBg = Color.green.opacity(0.1)
    static let normalText = Color.green
    
    // UI Constants
    static let cornerRadius: CGFloat = 20
    static let shadowRadius: CGFloat = 10
    static let shadowColor = Color.black.opacity(0.05)
    static let borderWidth: CGFloat = 1
    
    // Fonts
    static let titleFont = Font.system(size: 28, weight: .bold, design: .rounded)
    static let headerFont = Font.system(size: 20, weight: .bold, design: .rounded)
    static let bodyFont = Font.system(size: 16, weight: .regular, design: .rounded)
    static let captionFont = Font.system(size: 12, weight: .medium, design: .rounded)
}

extension View {
    func stickerStyle() -> some View {
        self.padding(12)
            .background(AppTheme.cardBackgroundColor)
            .cornerRadius(AppTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
            )
            .shadow(color: AppTheme.shadowColor, radius: AppTheme.shadowRadius, x: 0, y: 4)
    }
    
    func cardStyle() -> some View {
        self.padding()
            .background(AppTheme.cardBackgroundColor)
            .cornerRadius(AppTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
            )
            .shadow(color: AppTheme.shadowColor, radius: AppTheme.shadowRadius, x: 0, y: 2)
    }
}
