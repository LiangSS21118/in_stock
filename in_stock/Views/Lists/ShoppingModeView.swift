import SwiftUI

struct ShoppingModeView: View {
    @ObservedObject var viewModel: ListViewModel
    
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
                        
                        // Custom Binding-like logic for Stepper in row
                        HStack(spacing: 12) {
                            Button { viewModel.updateQuantity(for: item.id, increment: false) } label: {
                                Image(systemName: "minus.circle").foregroundColor(.gray)
                            }
                            Text("\(item.quantity)")
                                .font(AppTheme.bodyFont.bold())
                                .frame(width: 20)
                            Button { viewModel.updateQuantity(for: item.id, increment: true) } label: {
                                Image(systemName: "plus.circle").foregroundColor(.black)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
                }
                
                // Add Item Row
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus")
                        Text("新增品項")
                        Spacer()
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
}
