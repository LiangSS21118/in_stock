import SwiftUI

struct PaperChecklistCard<Content: View>: View {
    let title: String
    let dateString: String?
    let progressText: String
    let content: Content
    
    init(title: String, dateString: String? = nil, progressText: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.dateString = dateString
        self.progressText = progressText
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    if let dateString = dateString {
                        Text("Date: \(dateString)")
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    Text(title)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundColor(AppTheme.primaryText)
                }
                Spacer()
                Text("Progress: \(progressText)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(AppTheme.primaryText)
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(AppTheme.borderColor)
            
            VStack(alignment: .leading, spacing: 12) {
                content
            }
        }
        .padding(24)
        .background(Color(white: 0.99))
        .cornerRadius(AppTheme.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(AppTheme.borderColor, lineWidth: AppTheme.borderWidth)
        )
        .shadow(color: AppTheme.shadowColor, radius: 5, x: 2, y: 2)
    }
}
