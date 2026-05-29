import SwiftUI
import Foundation

struct NaturalLanguageInputView: View {
    @ObservedObject var viewModel: AddItemViewModel
    @ObservedObject var appViewModel: AppViewModel
    @State private var showConfirm = false
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("自然語言輸入")
                    .font(AppTheme.headerFont)
                
                ZStack(alignment: .topLeading) {
                    if viewModel.inputText.isEmpty {
                        Text("輸入你買了的物品")
                            .foregroundColor(.gray)
                            .padding(.top, 12)
                            .padding(.leading, 12)
                    }
                    TextEditor(text: $viewModel.inputText)
                        .frame(height: 150)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                }
                
                Text("範例：「我買了 3 瓶牛奶在 5/2 到期」")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondaryText)
            }
            .padding(.horizontal)
            
            PrimaryButton(title: viewModel.isParsing ? "解析中..." : "解析輸入內容", action: {
                viewModel.parseNaturalLanguage {
                    showConfirm = true
                }
            }, isDisabled: viewModel.inputText.isEmpty || viewModel.isParsing)
            .padding(.horizontal)
            
            if showConfirm {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("已辨識並自動填入")
                            .font(AppTheme.captionFont.bold())
                    }
                    .foregroundColor(.purple)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ResultRow(label: "品項", value: viewModel.itemName)
                        ResultRow(label: "數量", value: "\(Int(viewModel.quantity)) \(viewModel.unit)")
                        ResultRow(label: "到期日", value: dateFormatter.string(from: viewModel.expiryDate))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                    
                    NavigationLink(destination: AddItemConfirmView(viewModel: viewModel, appViewModel: appViewModel)) {
                        Text("下一步：確認細節")
                            .font(AppTheme.bodyFont.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(AppTheme.cornerRadius)
                    }
                }
                .padding(.horizontal)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            Spacer()
        }
        .padding(.top, 20)
        .background(AppTheme.backgroundColor)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd"
        return f
    }
}

struct ResultRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.bold)
        }
    }
}
