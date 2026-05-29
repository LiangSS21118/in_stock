import SwiftUI

struct SpaceView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var isShowingNewSpace = false
    @State private var newSpaceName = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
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
                        
                        Text("空間")
                            .font(AppTheme.titleFont)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    
                    // Space Grid
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
                isDisabled: spaceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            )

            Spacer()
        }
        .padding(24)
        .background(AppTheme.backgroundColor)
    }
}
