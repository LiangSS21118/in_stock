import SwiftUI

struct RestockConfirmationView: View {
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var entries: [ShoppingRestockEntry]

    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        self._entries = State(initialValue: viewModel.restockEntriesForCompletedShoppingItems())
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("回補庫存")
                                .font(AppTheme.titleFont)
                            Text("確認已買到的項目要如何寫回庫存。")
                                .font(AppTheme.bodyFont)
                                .foregroundColor(AppTheme.secondaryText)
                        }

                        if entries.isEmpty {
                            emptyState
                        } else {
                            ForEach($entries) { $entry in
                                RestockEntryCard(entry: $entry, spaces: viewModel.spaces)
                            }
                        }
                    }
                    .padding()
                }

                VStack(spacing: 12) {
                    PrimaryButton(title: entries.isEmpty ? "結束購物" : "確認回補") {
                        if entries.isEmpty {
                            viewModel.finishShoppingMode()
                        } else {
                            viewModel.restockFromCompletedShoppingItems(entries)
                        }
                        dismiss()
                    }

                    if !entries.isEmpty {
                        Button {
                            let skippedEntries = entries.map { entry in
                                var skippedEntry = entry
                                skippedEntry.shouldRestock = false
                                return skippedEntry
                            }
                            viewModel.restockFromCompletedShoppingItems(skippedEntries)
                            dismiss()
                        } label: {
                            Text("先不回補，結束購物")
                                .font(AppTheme.bodyFont.bold())
                                .foregroundColor(AppTheme.primaryText)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                    }
                }
                .padding()
                .background(Color.white)
            }
            .background(AppTheme.backgroundColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 32))
                .foregroundColor(AppTheme.primaryText)
            Text("沒有已勾選的購物項目")
                .font(AppTheme.headerFont)
            Text("可以直接結束購物，或回到清單勾選已買到的品項。")
                .font(AppTheme.bodyFont)
                .foregroundColor(AppTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
    }
}

private struct RestockEntryCard: View {
    @Binding var entry: ShoppingRestockEntry
    let spaces: [Space]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.name)
                        .font(AppTheme.headerFont)
                    Text("已買 \(entry.quantity) 件")
                        .font(AppTheme.captionFont)
                        .foregroundColor(AppTheme.secondaryText)
                }
                Spacer()
                Toggle("", isOn: $entry.shouldRestock)
                    .labelsHidden()
            }

            if entry.shouldRestock {
                if entry.isMatchedToInventory {
                    Label("已匹配原庫存", systemImage: "link")
                        .font(AppTheme.captionFont.bold())
                        .foregroundColor(AppTheme.secondaryText)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Picker("空間", selection: $entry.spaceId) {
                            ForEach(spaces) { space in
                                Text(space.name).tag(Optional(space.id))
                            }
                        }
                        .pickerStyle(.menu)
                        .disabled(spaces.isEmpty)

                        TextField("位置（選填）", text: $entry.locationText)
                            .font(AppTheme.bodyFont)
                            .padding(12)
                            .background(AppTheme.backgroundColor)
                            .cornerRadius(10)
                    }
                }
            } else {
                Text("略過此項，不寫回庫存。")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondaryText)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
    }
}
