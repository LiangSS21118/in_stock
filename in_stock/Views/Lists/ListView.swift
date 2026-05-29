import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    HStack {
                        Text("清單")
                            .font(AppTheme.titleFont)
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                    }
                    .padding(.horizontal)

                    // Segmented Control
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
