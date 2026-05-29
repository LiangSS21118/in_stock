import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var isShowingRestockConfirmation = false
    @State private var isSearchActive = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    if isSearchActive {
                        searchBar
                    } else {
                        HStack {
                            Text(viewModel.isShoppingFocusActive ? "購物模式" : "清單")
                                .font(AppTheme.titleFont)
                            Spacer()
                            if viewModel.isShoppingFocusActive {
                                Image(systemName: "cart.fill")
                                    .font(.system(size: 20))
                            } else {
                                Button {
                                    withAnimation(.spring()) {
                                        isSearchActive = true
                                    }
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

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
                        
                        if viewModel.selectedListMode == .shopping && !viewModel.isShoppingFocusActive {
                            Button {
                                viewModel.startShoppingMode()
                            } label: {
                                HStack {
                                    Image(systemName: "bolt.fill")
                                    Text("開啟專注購物模式")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .font(AppTheme.captionFont.bold())
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(Color.black)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal)
                            .padding(.top, -8)
                        }
                    }
                }
                .padding(.vertical, 20)
                .background(AppTheme.backgroundColor)

                // Content
                ScrollView {
                    if isSearchActive && !viewModel.searchText.trimmedForUserInput.isEmpty {
                        SearchToAddResultsView(viewModel: viewModel)
                    } else {
                        if viewModel.selectedListMode == .checklist {
                            ChecklistModeView(viewModel: viewModel)
                        } else {
                            ShoppingModeView(viewModel: viewModel)
                        }
                    }
                    Spacer(minLength: 100)
                }
                .background(AppTheme.backgroundColor)

                if viewModel.selectedListMode == .shopping {
                    VStack(spacing: 0) {
                        Divider()
                        PrimaryButton(title: "購物完畢", action: {
                            isShowingRestockConfirmation = true
                        }, isDisabled: viewModel.shoppingItems.filter(\.isChecked).isEmpty)
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
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("搜尋物品加入清單...", text: $viewModel.searchText)
                    .font(AppTheme.bodyFont)
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color(white: 0.95))
            .cornerRadius(10)
            
            Button("取消") {
                withAnimation(.spring()) {
                    isSearchActive = false
                    viewModel.searchText = ""
                }
            }
            .font(AppTheme.bodyFont.bold())
            .foregroundColor(.black)
        }
        .padding(.horizontal)
    }
}

struct SearchToAddResultsView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var addedItemIds: Set<UUID> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "可加入品項")
                .padding(.horizontal)

            if viewModel.filteredItems.isEmpty {
                VStack(spacing: 12) {
                    Text("找不到相關物品")
                        .font(AppTheme.bodyFont)
                        .foregroundColor(AppTheme.secondaryText)
                    
                    Button {
                        viewModel.addShoppingItem(name: viewModel.searchText)
                        viewModel.searchText = ""
                    } label: {
                        Text("直接新增「\(viewModel.searchText)」")
                            .font(AppTheme.bodyFont.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.filteredItems) { item in
                        SearchToAddRow(
                            item: item,
                            isAdded: viewModel.isInShoppingList(item) || addedItemIds.contains(item.id)
                        ) {
                            viewModel.addLowStockItemToShoppingList(item)
                            addedItemIds.insert(item.id)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SearchToAddRow: View {
    let item: Item
    let isAdded: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Text(item.imageName)
                .font(.system(size: 24))
                .frame(width: 40, height: 40)
                .background(Color(white: 0.95))
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
                HStack(spacing: 4) {
                    Image(systemName: isAdded ? "checkmark" : "plus")
                    Text(isAdded ? "已加入" : "加入")
                }
                .font(AppTheme.captionFont.bold())
                .foregroundColor(isAdded ? .gray : .white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isAdded ? Color(white: 0.9) : Color.black)
                .cornerRadius(10)
            }
            .disabled(isAdded)
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.borderColor, lineWidth: 1))
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
