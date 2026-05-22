import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: AppViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("歡迎回來,")
                            .font(AppTheme.bodyFont)
                            .foregroundColor(AppTheme.secondaryText)
                        Text(viewModel.currentUser.name)
                            .font(AppTheme.titleFont)
                    }
                    Spacer()
                    Image(systemName: "bell")
                        .font(.system(size: 20))
                        .padding(12)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(AppTheme.borderColor, lineWidth: 1))
                }
                .padding(.horizontal)
                
                // Status Summary Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    StatCard(iconName: "cart", title: "購物清單", value: "\(viewModel.shoppingListCount) 項")
                    StatCard(iconName: "trash", title: "斷捨離清單", value: "\(viewModel.declutterTodoCount) 項")
                    StatCard(iconName: "exclamationmark.triangle", title: "快用完", value: "\(viewModel.lowStockItems.count) 項")
                    StatCard(iconName: "clock", title: "即將過期", value: "\(viewModel.expiringSoonItems.count) 項")
                }
                .padding(.horizontal)
                
                // Low Stock Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "快用完")
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.lowStockItems) { item in
                                StickerItemCard(item: item)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Expiring Soon Section
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "即將過期")
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.expiringSoonItems) { item in
                                StickerItemCard(item: item)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Reminder Center
                VStack(alignment: .leading, spacing: 16) {
                    SectionHeader(title: "提醒中心")
                        .padding(.horizontal)
                    
                    ReminderCenterView(notifications: viewModel.notifications)
                        .padding(.horizontal)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.top, 20)
        }
        .background(AppTheme.backgroundColor)
    }
}
