import SwiftUI
import Combine
import Foundation

@MainActor
class AppViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var currentUser: User = MockData.shared.currentUser
    @Published var spaces: [Space] = MockData.shared.spaces
    @Published var items: [Item] = MockData.shared.items
    @Published var notifications: [NotificationItem] = MockData.shared.notifications
    @Published var declutterItems: [DeclutterItem] = MockData.shared.declutterItems
    @Published var achievements: [Achievement] = MockData.shared.achievements
    
    init() {
    }
    
    // Computed Properties for Dashboard
    var lowStockItems: [Item] {
        items.filter { $0.status == .lowStock }
    }
    
    var expiringSoonItems: [Item] {
        items.filter { $0.status == .expiringSoon }
    }
    
    var shoppingListCount: Int {
        MockData.shared.shoppingItems.count
    }
    
    var declutterTodoCount: Int {
        declutterItems.count
    }
    
    // Operations
    func addItem(_ item: Item) {
        items.append(item)
        // Auto-assign to space's local items array if needed, 
        // but in this mock we keep items as a flat list
    }
    
    func updateItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
        }
    }
    
    func deleteItem(_ id: UUID) {
        items.removeAll(where: { $0.id == id })
    }
    
    func itemsForSpace(_ spaceId: UUID) -> [Item] {
        items.filter { $0.spaceId == spaceId }
    }
}
