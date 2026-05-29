import SwiftUI

struct SpaceView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var isShowingNewSpace = false
    @State private var newSpaceName = ""
    @State private var isSearchActive = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if isSearchActive {
                        searchBar
                    } else {
                        // Header Illustration (ASCII House)
                        VStack(spacing: 8) {
                            Text("""
                                       _^_
                                     /|_|_\\
                                    |  [ ]  |
                                    |_______|
                            """)
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(AppTheme.primaryText)
                            
                            HStack {
                                Text("空間")
                                    .font(AppTheme.titleFont)
                                Spacer()
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
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    }
                    
                    if isSearchActive {
                        searchResultGrid
                    } else {
                        spaceGrid
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .background(AppTheme.backgroundColor)
            .sheet(isPresented: $isShowingNewSpace) {
                NewSpaceSheet(spaceName: $newSpaceName) {
                    viewModel.addSpace(name: newSpaceName)
                    newSpaceName = ""
                    isShowingNewSpace = false
                }
                .presentationDetents([.height(260)])
            }
        }
    }

    private var spaceGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            // Add New Space Button
            Button {
                isShowingNewSpace = true
            } label: {
                AddPlaceholderCard(text: "新增空間分類")
            }
            
            ForEach(viewModel.spaces) { space in
                NavigationLink(destination: SpaceDetailView(viewModel: viewModel, space: space)) {
                    SpaceCard(space: space)
                }
            }
        }
        .padding(.horizontal)
    }

    private var searchResultGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeader(title: "搜尋結果")
                .padding(.horizontal)

            if viewModel.filteredItems.isEmpty {
                Text(viewModel.searchText.isEmpty ? "輸入名稱搜尋庫存物品" : "找不到相關物品")
                    .font(AppTheme.bodyFont)
                    .foregroundColor(AppTheme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.filteredItems) { item in
                        StickerItemCard(item: item)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("搜尋庫存物品...", text: $viewModel.searchText)
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
        .padding(.top, 20)
    }
}

private struct NewSpaceSheet: View {
    @Binding var spaceName: String
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("新增空間分類")
                    .font(AppTheme.headerFont)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(AppTheme.primaryText)
                }
            }

            AuthTextField(placeholder: "例如：儲藏室", text: $spaceName)

            PrimaryButton(
                title: "新增",
                action: onSave,
                isDisabled: spaceName.trimmedForUserInput.isEmpty
            )

            Spacer()
        }
        .padding(24)
        .background(AppTheme.backgroundColor)
    }
}
