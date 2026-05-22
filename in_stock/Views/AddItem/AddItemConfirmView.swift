import SwiftUI
import Combine

struct AddItemConfirmView: View {
    @ObservedObject var viewModel: AddItemViewModel
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    Text("確認物品資訊")
                        .font(AppTheme.titleFont)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                
                // Form
                VStack(spacing: 20) {
                    // Image Preview Placeholder
                    VStack {
                        Text(viewModel.itemName.contains("牛奶") ? "🥛" : "📦")
                            .font(.system(size: 80))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(Color.white)
                    .cornerRadius(AppTheme.cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.borderColor, lineWidth: 1))
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("物品名稱")
                            .font(AppTheme.captionFont.bold())
                        AuthTextField(placeholder: "例如：牛奶", text: $viewModel.itemName)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("數量")
                                .font(AppTheme.captionFont.bold())
                            HStack {
                                TextField("1", value: $viewModel.quantity, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.decimalPad)
                                TextField("單位", text: $viewModel.unit)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("到期日")
                            .font(AppTheme.captionFont.bold())
                        DatePicker("", selection: $viewModel.expiryDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("所在空間")
                            .font(AppTheme.captionFont.bold())
                        Picker("空間", selection: $viewModel.selectedSpaceId) {
                            ForEach(appViewModel.spaces) { space in
                                Text(space.name).tag(space.id)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                    }
                    
                    Toggle("設為耗品", isOn: $viewModel.isConsumable)
                        .font(AppTheme.bodyFont.bold())
                    
                    Text("耗品通常不會開啟斷捨離模式，且會追蹤剩餘百分比。")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                PrimaryButton(title: "新增到庫存", action: {
                    let newItem = Item(
                        name: viewModel.itemName,
                        imageName: viewModel.itemName.contains("牛奶") ? "🥛" : "📦",
                        quantity: viewModel.quantity,
                        unit: viewModel.unit,
                        remainingPercentage: 1.0,
                        expiryDate: viewModel.expiryDate,
                        spaceId: viewModel.selectedSpaceId,
                        locationText: "新增項目",
                        isConsumable: viewModel.isConsumable
                    )
                    appViewModel.addItem(newItem)
                    appViewModel.selectedTab = .home
                })
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .padding(.top, 20)
        }
        .background(AppTheme.backgroundColor)
        .navigationBarBackButtonHidden(true)
    }
}
