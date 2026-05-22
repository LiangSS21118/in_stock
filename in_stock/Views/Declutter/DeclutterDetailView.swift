import SwiftUI

struct DeclutterDetailView: View {
    let item: DeclutterItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Image
                VStack {
                    Text(item.imageName)
                        .font(.system(size: 120))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 250)
                .background(Color.white)
                .cornerRadius(AppTheme.cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.borderColor, lineWidth: 1))
                .padding(.horizontal)
                
                // Info
                VStack(alignment: .leading, spacing: 16) {
                    Text(item.name)
                        .font(AppTheme.titleFont)
                    
                    HStack(spacing: 20) {
                        InfoBlock(label: "位置", value: item.locationText)
                        InfoBlock(label: "新增日期", value: dateFormatter.string(from: item.createdAt))
                    }
                    
                    Rectangle().frame(height: 1).foregroundColor(AppTheme.borderColor)
                    
                    NavigationLink(destination: DeclutterSettingsView()) {
                        HStack {
                            Text("斷捨離設定")
                                .font(AppTheme.headerFont)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top, 20)
        }
        .background(AppTheme.backgroundColor)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd"
        return f
    }
}

struct InfoBlock: View {
    let label: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(AppTheme.captionFont).foregroundColor(.gray)
            Text(value).font(AppTheme.bodyFont.bold())
        }
    }
}
