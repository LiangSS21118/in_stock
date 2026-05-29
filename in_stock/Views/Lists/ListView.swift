import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var isShowingRestockConfirmation = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        Text(viewModel.isShoppingFocusActive ? "購物模式" : "清單")
                            .font(AppTheme.titleFont)
                        Spacer()
                        if viewModel.isShoppingFocusActive {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 20))
                        } else {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20))
                        }
                    }
                    .padding(.horizontal)

                    // Segmented Control
                    if viewModel.isShoppingFocusActive {
                        HStack(spacing: 8) {
                            Image(systemName: "moon")
                            Text("專注採買中")
                            Spacer()
                            Text("\(viewModel.shoppingListCount) 項未完成")
                        }
                        .font(AppTheme.captionFont.bold())
                        .foregroundColor(AppTheme.primaryText)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppTheme.borderColor, lineWidth: 1)
                        )
                        .padding(.horizontal)
                    } else {
                        HStack(spacing: 0) {
                            TabButton(title: "清單模式", isSelected: viewModel.selectedListMode == .checklist) {
                                viewModel.selectedListMode = .checklist
                            }
                            TabButton(title: "購物模式", isSelected: viewModel.selectedListMode == .shopping) {
                                viewModel.selectedListMode = .shopping
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppTheme.borderColor, lineWidth: 1)
                                .padding(.horizontal)
                        )
                    }
                }
                .padding(.vertical, 20)
                .background(AppTheme.backgroundColor)

                // Content
                ScrollView {
                    if viewModel.selectedListMode == .checklist {
                        ChecklistModeView(viewModel: viewModel)
                    } else {
                        ShoppingModeView(viewModel: viewModel)
                    }
                    Spacer(minLength: 100)
                }
                .background(AppTheme.backgroundColor)

                if viewModel.isShoppingFocusActive {
                    VStack(spacing: 0) {
                        Divider()
                        PrimaryButton(title: "購物完畢") {
                            isShowingRestockConfirmation = true
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                        .padding(.bottom, 16)
                    }
                    .background(Color.white)
                }
            }
            .fullScreenCover(isPresented: $isShowingRestockConfirmation) {
                RestockConfirmationView(viewModel: viewModel)
            }
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.bodyFont.bold())
                .foregroundColor(isSelected ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color.black : Color.clear)
                .cornerRadius(10)
        }
    }
}
