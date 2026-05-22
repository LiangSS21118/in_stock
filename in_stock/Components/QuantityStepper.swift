import SwiftUI

struct QuantityStepper: View {
    @Binding var value: Int
    var minValue: Int = 1
    var maxValue: Int = 99
    
    var body: some View {
        HStack(spacing: 16) {
            Button {
                if value > minValue { value -= 1 }
            } label: {
                Image(systemName: "minus")
                    .foregroundColor(value > minValue ? AppTheme.primaryText : AppTheme.borderColor)
                    .frame(width: 32, height: 32)
                    .background(AppTheme.cardBackgroundColor)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(AppTheme.borderColor, lineWidth: 1))
            }
            
            Text("\(value)")
                .font(AppTheme.bodyFont.bold())
                .foregroundColor(AppTheme.primaryText)
                .frame(minWidth: 24, alignment: .center)
            
            Button {
                if value < maxValue { value += 1 }
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(value < maxValue ? AppTheme.primaryText : AppTheme.borderColor)
                    .frame(width: 32, height: 32)
                    .background(AppTheme.cardBackgroundColor)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(AppTheme.borderColor, lineWidth: 1))
            }
        }
    }
}
