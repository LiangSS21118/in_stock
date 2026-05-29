import SwiftUI

struct DeclutterSettingsView: View {
    @ObservedObject var viewModel: AppViewModel
    let item: DeclutterItem

    @State private var reason: String
    @State private var lastUsed: Date
    @State private var cycle: String
    @State private var message: String
    @Environment(\.dismiss) private var dismiss
    
    let cycles = ["1 個月", "3 個月", "6 個月", "1 年"]

    init(viewModel: AppViewModel, item: DeclutterItem) {
        self.viewModel = viewModel
        self.item = item
        _reason = State(initialValue: item.reason)
        _lastUsed = State(initialValue: item.lastUsedDate ?? Date())
        _cycle = State(initialValue: item.reminderCycle)
        _message = State(initialValue: item.futureMessage)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("斷捨離設定")
                        .font(AppTheme.titleFont)
                    Text("非耗品才需要填寫這些斷捨離內容。")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.secondaryText)
                }
                .padding(.horizontal)
                
                VStack(spacing: 24) {
                    // Question 1
                    VStack(alignment: .leading, spacing: 12) {
                        Text("這件物品對你來說？")
                            .font(AppTheme.headerFont)
                        AuthTextField(placeholder: "例如：很少使用 / 不再喜歡", text: $reason)
                    }
                    
                    // Question 2
                    VStack(alignment: .leading, spacing: 12) {
                        Text("上次使用時間")
                            .font(AppTheme.headerFont)
                        DatePicker("", selection: $lastUsed, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                    }
                    
                    // Question 3
                    VStack(alignment: .leading, spacing: 12) {
                        Text("提醒週期")
                            .font(AppTheme.headerFont)
                        Picker("選擇週期", selection: $cycle) {
                            ForEach(cycles, id: \.self) { c in
                                Text(c)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                    }
                    
                    // Question 4
                    VStack(alignment: .leading, spacing: 12) {
                        Text("給未來的自己說？")
                            .font(AppTheme.headerFont)
                        TextEditor(text: $message)
                            .frame(height: 100)
                            .padding(8)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                            .overlay(
                                Group {
                                    if message.isEmpty {
                                        Text("寫下想對未來的自己說的話（選填）")
                                            .foregroundColor(.gray)
                                            .padding(.top, 16)
                                            .padding(.leading, 12)
                                    }
                                }, alignment: .topLeading
                            )
                    }
                }
                .padding(.horizontal)
                
                PrimaryButton(title: "儲存設定", action: {
                    viewModel.updateDeclutterSettings(
                        for: item.id,
                        reason: reason,
                        lastUsedDate: lastUsed,
                        reminderCycle: cycle,
                        futureMessage: message
                    )
                    dismiss()
                })
                    .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
            .padding(.top, 20)
        }
        .background(AppTheme.backgroundColor)
    }
}
