import Foundation

struct ShoppingListItem: Identifiable {
    let id: UUID
    var name: String
    var quantity: Int
    var isChecked: Bool
    var sourceItemId: UUID?
    
    init(id: UUID = UUID(), name: String, quantity: Int = 1, isChecked: Bool = false, sourceItemId: UUID? = nil) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.isChecked = isChecked
        self.sourceItemId = sourceItemId
    }
}

struct ShoppingRestockEntry: Identifiable {
    let id: UUID
    var name: String
    var quantity: Int
    var matchedItemId: UUID?
    var spaceId: UUID?
    var locationText: String
    var shouldRestock: Bool

    var isMatchedToInventory: Bool {
        matchedItemId != nil
    }
}
