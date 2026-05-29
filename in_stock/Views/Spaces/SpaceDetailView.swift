import SwiftUI

struct SpaceDetailView: View {
    @ObservedObject var viewModel: AppViewModel
    let space: Space
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // ASCII Art Header for the specific space
                VStack(spacing: 16) {
                    Text(space.asciiArtText)
                        .font(.system(size: 14, weight: .regular, design: .monospaced))
                        .foregroundColor(AppTheme.primaryText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(AppTheme.cornerRadius)
                        .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadius).stroke(AppTheme.borderColor, lineWidth: 1))
                    
                    Text(space.name)
                        .font(AppTheme.titleFont)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                // Item Grid
                let items = viewModel.itemsForSpace(space.id)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    // Add Item in this space
                    Button {
                        viewModel.startAddingItem(in: space.id)
                    } label: {
                        AddPlaceholderCard(text: "新增物品")
                    }
                    
                    ForEach(items) { item in
                        StickerItemCard(item: item)
                    }
                }
                .padding(.horizontal)
                
                Spacer(minLength: 40)
            }
            .padding(.top, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(AppTheme.backgroundColor)
    }
}
