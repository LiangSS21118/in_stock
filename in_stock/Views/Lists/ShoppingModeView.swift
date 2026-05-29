import SwiftUI

struct ShoppingModeView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var newItemName = ""
    @State private var recentlyIncrementedItemIds: Set<UUID> = []

    var body: some View {
        VStack(spacing: 20) {
            shoppingListCard
            declutterListCard
        }
        .padding(.horizontal)
    }

    private var shoppingListCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("購物清單", systemImage: "cart.fill")
                    .font(AppTheme.headerFont)
                Spacer()
                Text("\(viewModel.shoppingListCount) / \(viewModel.shoppingItems.count)")
                    .font(AppTheme.captionFont.bold())
                    .foregroundColor(AppTheme.secondaryText)
            }

            Divider()

            if viewModel.shoppingItems.isEmpty {
                Text("目前沒有待買品項")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.shoppingItems) { item in
                        ShoppingItemRow(
                            item: item,
                            quantity: quantityBinding(for: item)
                        ) {
                            viewModel.toggleShoppingItem(item.id)
                        }
                    }
                }
            }

            addItemRow

            if !viewModel.lowStockItems.isEmpty {
                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("當前缺乏")
                        .font(AppTheme.captionFont.bold())
                        .foregroundColor(AppTheme.secondaryText)

                    ForEach(viewModel.lowStockItems) { item in
                        LowStockQuickAddRow(
                            item: item,
                            actionTitle: actionTitle(for: item)
                        ) {
                            addLowStockItem(item)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
    }

    private var addItemRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "plus")
                .foregroundColor(AppTheme.secondaryText)

            TextField("新增品項", text: $newItemName)
                .font(AppTheme.bodyFont)
                .submitLabel(.done)
                .onSubmit(addShoppingItem)

            Button(action: addShoppingItem) {
                Text("加入")
                    .font(AppTheme.captionFont.bold())
                    .foregroundColor(newItemName.trimmedForUserInput.isEmpty ? AppTheme.secondaryText : AppTheme.primaryText)
            }
            .disabled(newItemName.trimmedForUserInput.isEmpty)
        }
        .padding()
        .background(AppTheme.backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                .foregroundColor(AppTheme.borderColor)
        )
    }

    private var declutterListCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label("斷捨離清單", systemImage: "leaf")
                    .font(AppTheme.headerFont)
                Spacer()
                Text(viewModel.declutterProgress)
                    .font(AppTheme.captionFont.bold())
                    .foregroundColor(AppTheme.secondaryText)
            }

            Divider()

            ForEach(viewModel.declutterTodos) { item in
                Button {
                    viewModel.toggleDeclutterTodo(item.id)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                            .font(.system(size: 22))
                            .foregroundColor(item.isChecked ? AppTheme.primaryText : AppTheme.secondaryText)

                        Text(item.name)
                            .font(AppTheme.bodyFont)
                            .strikethrough(item.isChecked)
                            .foregroundColor(item.isChecked ? AppTheme.secondaryText : AppTheme.primaryText)

                        Spacer()
                    }
                }
                .buttonStyle(.plain)
            }

            NavigationLink(destination: DeclutterView(viewModel: viewModel)) {
                HStack {
                    Text("查看全部")
                        .font(AppTheme.captionFont.bold())
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(AppTheme.primaryText)
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
    }

    private func addShoppingItem() {
        viewModel.addShoppingItem(name: newItemName)
        newItemName = ""
    }

    private func addLowStockItem(_ item: Item) {
        let wasAlreadyAdded = viewModel.isInShoppingList(item)
        viewModel.addLowStockItemToShoppingList(item)

        if wasAlreadyAdded {
            recentlyIncrementedItemIds.insert(item.id)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                recentlyIncrementedItemIds.remove(item.id)
            }
        }
    }

    private func actionTitle(for item: Item) -> String {
        if recentlyIncrementedItemIds.contains(item.id) {
            return "數量 +1"
        }

        return viewModel.isInShoppingList(item) ? "已加入" : "加入"
    }

    private func quantityBinding(for item: ShoppingListItem) -> Binding<Int> {
        Binding(
            get: {
                viewModel.shoppingItems.first(where: { $0.id == item.id })?.quantity ?? item.quantity
            },
            set: {
                viewModel.setShoppingItemQuantity(for: item.id, quantity: $0)
            }
        )
    }
}

private struct ShoppingItemRow: View {
    let item: ShoppingListItem
    @Binding var quantity: Int
    let toggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: toggle) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(item.isChecked ? AppTheme.primaryText : AppTheme.secondaryText)
            }

            Text(item.name)
                .font(AppTheme.bodyFont.bold())
                .strikethrough(item.isChecked)
                .foregroundColor(item.isChecked ? AppTheme.secondaryText : AppTheme.primaryText)

            Spacer()

            QuantityStepper(value: $quantity, maxValue: 24)
        }
        .padding(.vertical, 4)
    }
}

private struct LowStockQuickAddRow: View {
    let item: Item
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(item.imageName)
                .font(.system(size: 24))
                .frame(width: 36, height: 36)
                .background(AppTheme.backgroundColor)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(AppTheme.bodyFont.bold())
                    .foregroundColor(AppTheme.primaryText)
                Text("\(item.locationText) · 剩餘 \(Int(item.remainingPercentage * 100))%")
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondaryText)
            }

            Spacer()

            Button(action: action) {
                Text(actionTitle)
                    .font(AppTheme.captionFont.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.black)
                    .cornerRadius(10)
            }
        }
        .padding(12)
        .background(AppTheme.backgroundColor)
        .cornerRadius(12)
    }
}
