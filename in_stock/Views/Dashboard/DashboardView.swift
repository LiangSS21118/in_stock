import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        NavigationStack {
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

                    Button {
                        viewModel.startShoppingMode()
                    } label: {
                        ShoppingModeEntryCard(
                            pendingItems: viewModel.shoppingListCount,
                            lowStockItems: viewModel.lowStockItems.count
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal)

                    // Status Summary Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        Button {
                            viewModel.startShoppingMode()
                        } label: {
                            StatCard(iconName: "cart", title: "購物清單", value: "\(viewModel.shoppingListCount) 項")
                        }
                        .buttonStyle(.plain)

                        NavigationLink(destination: DeclutterView(viewModel: viewModel)) {
                            StatCard(iconName: "trash", title: "斷捨離清單", value: "\(viewModel.declutterTodoCount) 項")
                        }
                        .buttonStyle(.plain)

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
}

private struct ShoppingModeEntryCard: View {
    let pendingItems: Int
    let lowStockItems: Int

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "cart.fill")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(Color.white.opacity(0.12))
                .cornerRadius(14)

            VStack(alignment: .leading, spacing: 6) {
                Text("購物模式")
                    .font(AppTheme.headerFont)
                    .foregroundColor(.white)
                Text("開始採買 · \(pendingItems) 項待買，\(lowStockItems) 項快用完")
                    .font(AppTheme.captionFont)
                    .foregroundColor(.white.opacity(0.72))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.72))
        }
        .padding(20)
        .background(Color.black)
        .cornerRadius(AppTheme.cornerRadius)
    }
}
