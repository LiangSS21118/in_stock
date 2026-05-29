import SwiftUI
import Foundation
import Combine

@MainActor
class AppViewModel: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var selectedListMode: ListMode = .checklist
    @Published var isShoppingFocusActive = false
    @Published var currentUser: User = MockData.shared.currentUser
    @Published var spaces: [Space] = MockData.shared.spaces
    @Published var items: [Item] = MockData.shared.items
    @Published var shoppingItems: [ShoppingListItem] = MockData.shared.shoppingItems
    @Published var declutterTodos: [ShoppingListItem] = MockData.shared.declutterTodos
    @Published var notifications: [NotificationItem] = MockData.shared.notifications
    @Published var declutterItems: [DeclutterItem] = MockData.shared.declutterItems
    @Published var achievements: [Achievement] = MockData.shared.achievements
    @Published var pendingAddSpaceId: UUID?

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
        declutterTodos.filter { !$0.isChecked }.count
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
        let trimmedName = name.trimmedForUserInput
        guard !trimmedName.isEmpty else { return }

        let newSpace = Space(
            name: trimmedName,
            illustrationName: "square.grid.2x2",
            asciiArtText: Space.placeholderAsciiArt(for: trimmedName)
        )
        spaces.append(newSpace)
    }

    // Shopping list operations
    func startShoppingMode() {
        isShoppingFocusActive = true
        selectedListMode = .shopping
        selectedTab = .lists
    }

    func pauseShoppingMode() {
        isShoppingFocusActive = false
    }

    func finishShoppingMode() {
        isShoppingFocusActive = false
        selectedListMode = .checklist
        selectedTab = .home
    }

    func toggleShoppingItem(_ id: UUID) {
        if let index = shoppingItems.firstIndex(where: { $0.id == id }) {
            shoppingItems[index].isChecked.toggle()
        }
    }

    func updateShoppingItemQuantity(for id: UUID, increment: Bool) {
        guard let item = shoppingItems.first(where: { $0.id == id }) else { return }
        setShoppingItemQuantity(for: id, quantity: item.quantity + (increment ? 1 : -1))
    }

    func setShoppingItemQuantity(for id: UUID, quantity: Int) {
        guard let index = shoppingItems.firstIndex(where: { $0.id == id }) else { return }
        shoppingItems[index].quantity = max(1, quantity)
    }

    func addShoppingItem(name: String) {
        let trimmedName = name.trimmedForUserInput
        guard !trimmedName.isEmpty else { return }

        if let index = shoppingItems.firstIndex(where: { $0.name == trimmedName }) {
            shoppingItems[index].quantity += 1
        } else {
            shoppingItems.append(ShoppingListItem(name: trimmedName))
        }
    }

    func addLowStockItemToShoppingList(_ item: Item) {
        if let sourceIndex = shoppingItems.firstIndex(where: { $0.sourceItemId == item.id }) {
            shoppingItems[sourceIndex].quantity += 1
            shoppingItems[sourceIndex].isChecked = false
            return
        }

        if let nameIndex = shoppingItems.firstIndex(where: { namesMatch($0.name, item.name) }) {
            shoppingItems[nameIndex].quantity += 1
            shoppingItems[nameIndex].isChecked = false
            shoppingItems[nameIndex].sourceItemId = item.id
            return
        }

        shoppingItems.append(
            ShoppingListItem(name: item.name, quantity: 1, sourceItemId: item.id)
        )
    }

    func isInShoppingList(_ item: Item) -> Bool {
        shoppingItems.contains { shoppingItem in
            shoppingItem.sourceItemId == item.id || namesMatch(shoppingItem.name, item.name)
        }
    }

    func restockEntriesForCompletedShoppingItems() -> [ShoppingRestockEntry] {
        shoppingItems
            .filter(\.isChecked)
            .map { shoppingItem in
                let matchedItem = matchedInventoryItem(for: shoppingItem)

                return ShoppingRestockEntry(
                    id: shoppingItem.id,
                    name: shoppingItem.name,
                    quantity: shoppingItem.quantity,
                    matchedItemId: matchedItem?.id,
                    spaceId: matchedItem?.spaceId ?? spaces.first?.id,
                    locationText: matchedItem?.locationText ?? "",
                    shouldRestock: true
                )
            }
    }

    func restockFromCompletedShoppingItems(_ entries: [ShoppingRestockEntry]) {
        let restockedEntries = entries.filter(\.shouldRestock)

        for entry in restockedEntries {
            if let matchedItemId = entry.matchedItemId,
               let itemIndex = items.firstIndex(where: { $0.id == matchedItemId }) {
                items[itemIndex].quantity += Double(entry.quantity)
                items[itemIndex].remainingPercentage = 1
                items[itemIndex].status = .inStock
                continue
            }

            guard let spaceId = entry.spaceId else { continue }

            let newItem = Item(
                name: entry.name,
                imageName: "📦",
                quantity: Double(entry.quantity),
                unit: "件",
                remainingPercentage: 1,
                spaceId: spaceId,
                locationText: entry.locationText.trimmedForUserInput.isEmpty ? "未分類位置" : entry.locationText.trimmedForUserInput,
                isConsumable: true,
                status: .inStock
            )
            items.append(newItem)
        }

        let completedIds = Set(entries.map(\.id))
        shoppingItems.removeAll { completedIds.contains($0.id) }
        finishShoppingMode()
    }

    func toggleDeclutterTodo(_ id: UUID) {
        if let index = declutterTodos.firstIndex(where: { $0.id == id }) {
            declutterTodos[index].isChecked.toggle()
        }
    }

    // Declutter operations
    func addDeclutterItem(name: String, locationText: String, action: DeclutterAction, reason: String = "") {
        let trimmedName = name.trimmedForUserInput
        guard !trimmedName.isEmpty else { return }

        let trimmedLocation = locationText.trimmedForUserInput
        let trimmedReason = reason.trimmedForUserInput
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

        declutterItems[index].reason = reason.trimmedForUserInput
        declutterItems[index].lastUsedDate = lastUsedDate
        declutterItems[index].reminderCycle = reminderCycle
        declutterItems[index].futureMessage = futureMessage.trimmedForUserInput
    }

    private func progressText(for rows: [ShoppingListItem]) -> String {
        let checked = rows.filter { $0.isChecked }.count
        return "\(checked) / \(rows.count)"
    }

    private func matchedInventoryItem(for shoppingItem: ShoppingListItem) -> Item? {
        if let sourceItemId = shoppingItem.sourceItemId,
           let sourcedItem = items.first(where: { $0.id == sourceItemId }) {
            return sourcedItem
        }

        return items.first { namesMatch($0.name, shoppingItem.name) }
    }

    private func namesMatch(_ lhs: String, _ rhs: String) -> Bool {
        lhs.trimmedForUserInput.localizedCaseInsensitiveCompare(rhs.trimmedForUserInput) == .orderedSame
    }

}
