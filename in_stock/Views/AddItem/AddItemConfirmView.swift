import SwiftUI

struct AddItemConfirmView: View {
    @ObservedObject var viewModel: AddItemViewModel
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.dismiss) var dismiss

    private let reminderThresholds: [Double] = [0.1, 0.2, 0.3, 0.5]

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
                VStack(spacing: 12) {
                    // Image Preview Placeholder
                    VStack {
                        Text(itemArtwork)
                            .font(.system(size: 80))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(Color.white)
                    .cornerRadius(AppTheme.cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.borderColor, lineWidth: 1))

                    FormRow(icon: "cube", title: "物品名稱") {
                        TextField("例如：牛奶", text: $viewModel.itemName)
                            .multilineTextAlignment(.trailing)
                            .font(AppTheme.bodyFont.bold())
                    }

                    FormRow(icon: "cylinder.split.1x2", title: "數量") {
                        HStack(spacing: 8) {
                            QuantityStepper(value: quantityBinding, maxValue: 99)
                            TextField("單位", text: $viewModel.unit)
                                .font(AppTheme.bodyFont.bold())
                                .multilineTextAlignment(.center)
                                .frame(width: 44)
                        }
                    }

                    FormRow(icon: "calendar", title: "到期日") {
                        DatePicker("", selection: $viewModel.expiryDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }

                    FormRow(icon: "house", title: "所在空間") {
                        Picker("空間", selection: $viewModel.selectedSpaceId) {
                            ForEach(appViewModel.spaces) { space in
                                Text(space.name).tag(space.id)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    FormRow(icon: "mappin.and.ellipse", title: "位置") {
                        TextField("例如：冰箱", text: $viewModel.locationText)
                            .multilineTextAlignment(.trailing)
                            .font(AppTheme.bodyFont.bold())
                    }

                    FormRow(icon: "bell", title: "提醒門檻") {
                        Picker("提醒門檻", selection: $viewModel.reminderThreshold) {
                            ForEach(reminderThresholds, id: \.self) { threshold in
                                Text("\(Int(threshold * 100))%").tag(threshold)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    Toggle("設為耗品", isOn: $viewModel.isConsumable)
                        .font(AppTheme.bodyFont.bold())
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                }
                .padding(.horizontal)

                PrimaryButton(title: "新增到庫存", action: {
                    let trimmedLocation = viewModel.locationText.trimmingCharacters(in: .whitespacesAndNewlines)
                    let expiryDate = viewModel.isConsumable ? viewModel.expiryDate : nil
                    let status = appViewModel.status(
                        for: expiryDate,
                        remainingPercentage: 1.0,
                        reminderThreshold: viewModel.reminderThreshold
                    )
                    let newItem = Item(
                        name: viewModel.itemName,
                        imageName: itemArtwork,
                        quantity: viewModel.quantity,
                        unit: viewModel.unit,
                        remainingPercentage: 1.0,
                        expiryDate: expiryDate,
                        spaceId: viewModel.selectedSpaceId,
                        locationText: trimmedLocation.isEmpty ? "新增項目" : trimmedLocation,
                        isConsumable: viewModel.isConsumable,
                        reminderThreshold: viewModel.reminderThreshold,
                        status: status
                    )
                    appViewModel.addItem(newItem)
                    viewModel.reset(defaultSpaceId: appViewModel.spaces.first?.id)
                    appViewModel.selectedTab = .home
                }, isDisabled: viewModel.itemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            .padding(.top, 20)
        }
        .background(AppTheme.backgroundColor)
        .navigationBarBackButtonHidden(true)
    }

    private var itemArtwork: String {
        viewModel.itemName.contains("牛奶") || viewModel.itemName.contains("鮮乳") ? "🥛" : "📦"
    }

    private var quantityBinding: Binding<Int> {
        Binding(
            get: { max(1, Int(viewModel.quantity.rounded())) },
            set: { viewModel.quantity = Double($0) }
        )
    }
}

private struct FormRow<Content: View>: View {
    let icon: String
    let title: String
    let content: Content

    init(icon: String, title: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(AppTheme.primaryText)
                .frame(width: 24)

            Text(title)
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.primaryText)

            Spacer()

            content
                .foregroundColor(AppTheme.primaryText)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
    }
}
