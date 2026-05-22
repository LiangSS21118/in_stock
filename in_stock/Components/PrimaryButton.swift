import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isDisabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.bodyFont.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isDisabled ? Color.gray : Color.black)
                .cornerRadius(AppTheme.cornerRadius)
        }
        .disabled(isDisabled)
    }
}
