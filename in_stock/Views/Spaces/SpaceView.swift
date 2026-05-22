import SwiftUI

struct SpaceView: View {
    @ObservedObject var viewModel: AppViewModel
    
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
                        Button(action: {}) {
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
        }
    }
}
