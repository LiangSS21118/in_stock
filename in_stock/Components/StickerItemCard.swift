import SwiftUI

struct StickerItemCard: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.imageName)
                .font(.system(size: 40))
                .padding(.bottom, 4)
            
            Text(item.name)
                .font(AppTheme.bodyFont)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.primaryText)
                .lineLimit(1)
            
            if item.status == .expiringSoon, let date = item.expiryDate {
                Text(dateFormatter.string(from: date))
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.expiringSoonText)
            } else {
                let formattedQuantity = String(format: "%g", item.quantity)
                let text = item.remainingPercentage < 0.3
                    ? "剩 \(Int(item.remainingPercentage * 100))%"
                    : "剩 \(formattedQuantity) \(item.unit)"
                
                Text(text)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondaryText)
            }
        }
        .frame(width: 120, alignment: .leading)
        .stickerStyle()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }
}
