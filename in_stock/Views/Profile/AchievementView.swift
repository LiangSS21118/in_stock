import SwiftUI

struct AchievementView: View {
    let achievements: [Achievement]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("我的成就")
                .font(AppTheme.headerFont)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(achievements) { ach in
                    VStack(alignment: .leading, spacing: 12) {
                        Image(systemName: ach.iconName)
                            .font(.system(size: 24))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(ach.title)
                                .font(AppTheme.captionFont)
                                .foregroundColor(.gray)
                            Text("\(formattedValue(ach.value)) \(ach.unit)")
                                .font(AppTheme.headerFont)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                }
            }
            
            // Milestone
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(.orange)
                    Text("下一個里程碑")
                        .font(AppTheme.bodyFont.bold())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("再斷捨離 22 件，解鎖新成就！")
                            .font(AppTheme.captionFont)
                        Spacer()
                        Text("128 / 150 件")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                    }
                    
                    ProgressView(value: 128, total: 150)
                        .tint(.black)
                        .background(Color.gray.opacity(0.2))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .cornerRadius(2)
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(AppTheme.cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.borderColor, lineWidth: 1))
        }
    }
    
    private func formattedValue(_ value: Double) -> String {
        if value == floor(value) {
            return String(format: "%.0f", value)
        } else {
            return String(format: "%.1f", value)
        }
    }
}
