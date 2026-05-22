import SwiftUI

struct DeclutterView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("斷捨離清單")
                            .font(AppTheme.titleFont)
                        Text("整理不需要的物品，讓空間與心更輕盈。")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.secondaryText)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        ForEach(viewModel.declutterItems) { item in
                            NavigationLink(destination: DeclutterDetailView(item: item)) {
                                DeclutterRow(item: item)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    PrimaryButton(title: "＋ 新增斷捨離項目", action: {})
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    Spacer(minLength: 100)
                }
            }
            .background(AppTheme.backgroundColor)
        }
    }
}

struct DeclutterRow: View {
    let item: DeclutterItem
    
    var body: some View {
        HStack(spacing: 16) {
            Text(item.imageName)
                .font(.system(size: 32))
                .frame(width: 60, height: 60)
                .background(Color(white: 0.95))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(AppTheme.bodyFont.bold())
                    .foregroundColor(.black)
                
                HStack(spacing: 8) {
                    Text(item.locationText)
                    Text("•")
                    Text(dateFormatter.string(from: item.createdAt))
                }
                .font(.system(size: 10))
                .foregroundColor(.gray)
                
                StatusBadge(
                    text: item.action.rawValue,
                    backgroundColor: badgeColor(item.action).opacity(0.1),
                    textColor: badgeColor(item.action)
                )
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(AppTheme.cornerRadius)
        .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.borderColor, lineWidth: 1))
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd"
        return f
    }
    
    private func badgeColor(_ action: DeclutterAction) -> Color {
        switch action {
        case .donate: return .green
        case .sellSecondHand: return .orange
        case .discard: return .red
        }
    }
}
