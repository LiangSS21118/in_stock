import SwiftUI
import Foundation

@MainActor
class AppViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var selectedListMode: ListMode = .checklist
    @Published var currentUser: User = MockData.shared.currentUser
    @Published var spaces: [Space] = MockData.shared.spaces
    @Published var items: [Item] = MockData.shared.items
    @Published var shoppingItems: [ShoppingListItem] = MockData.shared.shoppingItems
    @Published var declutterTodos: [ShoppingListItem] = MockData.shared.declutterTodos
    @Published var notifications: [NotificationItem] = MockData.shared.notifications
    @Published var declutterItems: [DeclutterItem] = MockData.shared.declutterItems
    @Published var achievements: [Achievement] = MockData.shared.achievements
    @Published var pendingAddSpaceId: UUID?
    
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
        shoppingItems.filter { !$0.isChecked }.count
    }
    
    var declutterTodoCount: Int {
        declutterItems.count
    }

    var shoppingProgress: String {
        progressText(for: shoppingItems)
    }

    var declutterProgress: String {
        progressText(for: declutterTodos)
    }
    
    // Inventory operations
    func addItem(_ item: Item) {
        items.append(item)
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

    func startAddingItem(in spaceId: UUID? = nil) {
        pendingAddSpaceId = spaceId
        selectedTab = .add
    }

    func consumePendingAddSpaceId() -> UUID? {
        defer { pendingAddSpaceId = nil }
        return pendingAddSpaceId
    }

    func status(for expiryDate: Date?, remainingPercentage: Double, reminderThreshold: Double) -> ItemStatus {
        if let expiryDate {
            let startOfToday = Calendar.current.startOfDay(for: Date())
            let startOfExpiry = Calendar.current.startOfDay(for: expiryDate)
            let daysUntilExpiry = Calendar.current.dateComponents([.day], from: startOfToday, to: startOfExpiry).day ?? 0

            if daysUntilExpiry < 0 {
                return .expired
            }

            if daysUntilExpiry <= 7 {
                return .expiringSoon
            }
        }

        if remainingPercentage <= reminderThreshold {
            return .lowStock
        }

        return .inStock
    }

    // Space operations
    func addSpace(name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let newSpace = Space(
            name: trimmedName,
            illustrationName: "square.grid.2x2",
            asciiArtText: asciiArt(for: trimmedName)
        )
        spaces.append(newSpace)
    }

    // Shopping list operations
    func toggleShoppingItem(_ id: UUID) {
        if let index = shoppingItems.firstIndex(where: { $0.id == id }) {
            shoppingItems[index].isChecked.toggle()
        }
    }

    func updateShoppingItemQuantity(for id: UUID, increment: Bool) {
        guard let index = shoppingItems.firstIndex(where: { $0.id == id }) else { return }

        if increment {
            shoppingItems[index].quantity += 1
        } else if shoppingItems[index].quantity > 1 {
            shoppingItems[index].quantity -= 1
        }
    }

    func addShoppingItem(name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        if let index = shoppingItems.firstIndex(where: { $0.name == trimmedName }) {
            shoppingItems[index].quantity += 1
        } else {
            shoppingItems.append(ShoppingListItem(name: trimmedName))
        }
    }

    func toggleDeclutterTodo(_ id: UUID) {
        if let index = declutterTodos.firstIndex(where: { $0.id == id }) {
            declutterTodos[index].isChecked.toggle()
        }
    }

    // Declutter operations
    func addDeclutterItem(name: String, locationText: String, action: DeclutterAction, reason: String = "") {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let trimmedLocation = locationText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        let newItem = DeclutterItem(
            name: trimmedName,
            imageName: "📦",
            locationText: trimmedLocation.isEmpty ? "未分類空間" : trimmedLocation,
            action: action,
            reason: trimmedReason
        )
        declutterItems.append(newItem)
        declutterTodos.append(ShoppingListItem(name: trimmedName))
    }

    func updateDeclutterSettings(
        for id: UUID,
        reason: String,
        lastUsedDate: Date?,
        reminderCycle: String,
        futureMessage: String
    ) {
        guard let index = declutterItems.firstIndex(where: { $0.id == id }) else { return }

        declutterItems[index].reason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        declutterItems[index].lastUsedDate = lastUsedDate
        declutterItems[index].reminderCycle = reminderCycle
        declutterItems[index].futureMessage = futureMessage.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func progressText(for rows: [ShoppingListItem]) -> String {
        let checked = rows.filter { $0.isChecked }.count
        return "\(checked) / \(rows.count)"
    }

    private func asciiArt(for name: String) -> String {
        if name.contains("廚") {
            return """
             [  ]  [  ]
             |__|__|__|
             |        |
             |________|
            """
        }

        if name.contains("衣") || name.contains("臥") {
            return """
              ________
             |  ____  |
             | |    | |
             |_|____|_|
            """
        }

        return """
          _______
         |       |
         |  [ ]  |
         |_______|
        """
    }
}
