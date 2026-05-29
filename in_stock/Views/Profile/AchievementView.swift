import SwiftUI

struct AchievementView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Illustration (ASCII Trophy)
                VStack(spacing: 8) {
                    Text("""
                                 ___________
                                '._==_==_=_.'
                                .-\\:      /-.
                               | (|:.     |) |
                                '-|:.     |-'
                                  \\::.    /
                                   '::. .'
                                     ) (
                                   _.' '._
                                  `-------`
                    """)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(AppTheme.primaryText)
                    
                    Text("斷捨離成就")
                        .font(AppTheme.titleFont)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                
                // Item Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.doneDeclutterItems) { item in
                        DoneDeclutterCard(item: item)
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

struct DoneDeclutterCard: View {
    let item: DeclutterItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.imageName)
                .font(.system(size: 40))
                .padding(.bottom, 4)
            
            Text(item.name)
                .font(AppTheme.bodyFont)
                .fontWeight(.bold)
                .foregroundColor(AppTheme.primaryText)
                .lineLimit(1)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.reason)
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondaryText)
                    .lineLimit(1)
                
                Text(AppDateFormatter.shortMonthDayString(from: item.createdAt))
                    .font(AppTheme.captionFont)
                    .foregroundColor(AppTheme.secondaryText.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .stickerStyle()
    }
}
