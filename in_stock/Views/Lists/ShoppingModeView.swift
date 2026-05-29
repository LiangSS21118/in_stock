import SwiftUI

struct ShoppingModeView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var newItemName = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Shopping Title
            HStack {
                Image(systemName: "cart.fill")
                Text("購物清單")
                    .font(AppTheme.headerFont)
                Spacer()
                Text("\(viewModel.shoppingItems.count) 項")
                    .font(AppTheme.captionFont)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            // List Items
            VStack(spacing: 12) {
                ForEach(viewModel.shoppingItems) { item in
                    HStack {
                        Button { viewModel.toggleShoppingItem(item.id) } label: {
                            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 24))
                                .foregroundColor(item.isChecked ? .black : .gray)
                        }
                        
                        Text(item.name)
                            .font(AppTheme.bodyFont.bold())
                            .foregroundColor(item.isChecked ? .gray : .black)
                        
                        Spacer()
                        
                        QuantityStepper(value: quantityBinding(for: item), maxValue: 24)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                }
                
                // Add Item Row
                HStack(spacing: 12) {
                    Image(systemName: "plus")
                        .foregroundColor(.gray)

                    TextField("新增品項", text: $newItemName)
                        .font(AppTheme.bodyFont)
                        .submitLabel(.done)
                        .onSubmit(addShoppingItem)

                    Button(action: addShoppingItem) {
                        Text("加入")
                            .font(AppTheme.captionFont.bold())
                            .foregroundColor(.black)
                    }
                    .disabled(newItemName.trimmedForUserInput.isEmpty)
                }
                .padding()
                .foregroundColor(.gray)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
                        .foregroundColor(AppTheme.borderColor)
                )

                NavigationLink(destination: DeclutterView(viewModel: viewModel)) {
                    HStack {
                        Image(systemName: "leaf")
                        Text("整理斷捨離清單")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding()
                    .foregroundColor(AppTheme.primaryText)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal)
            
            // Suggestions (Same as Checklist)
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(title: "建議購入")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        SuggestionItemView(image: "🥛", name: "牛奶")
                        SuggestionItemView(image: "🥚", name: "雞蛋")
                        SuggestionItemView(image: "🧴", name: "洗髮精")
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func addShoppingItem() {
        viewModel.addShoppingItem(name: newItemName)
        newItemName = ""
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
