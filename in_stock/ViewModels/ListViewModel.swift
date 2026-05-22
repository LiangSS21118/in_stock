import SwiftUI
import Combine

@MainActor
class ListViewModel: ObservableObject {
    @Published var selectedMode: ListMode = .checklist
    @Published var shoppingItems: [ShoppingListItem] = []
    @Published var declutterTodos: [ShoppingListItem] = [] // Reusing same model for checklist rows
    
    init() {
        self.shoppingItems = MockData.shared.shoppingItems
        
        // Mock declutter todos
        self.declutterTodos = [
            ShoppingListItem(name: "玄關備用傘", isChecked: false),
            ShoppingListItem(name: "重複購買的馬克杯", isChecked: true)
        ]
    }
    
    var shoppingProgress: String {
        let checked = shoppingItems.filter { $0.isChecked }.count
        return "\(checked) / \(shoppingItems.count)"
    }
    
    var declutterProgress: String {
        let checked = declutterTodos.filter { $0.isChecked }.count
        return "\(checked) / \(declutterTodos.count)"
    }
    
    func toggleShoppingItem(_ id: UUID) {
        if let index = shoppingItems.firstIndex(where: { $0.id == id }) {
            shoppingItems[index].isChecked.toggle()
        }
    }
    
    func updateQuantity(for id: UUID, increment: Bool) {
        if let index = shoppingItems.firstIndex(where: { $0.id == id }) {
            if increment {
                shoppingItems[index].quantity += 1
            } else if shoppingItems[index].quantity > 1 {
                shoppingItems[index].quantity -= 1
            }
        }
    }
    
    func addShoppingItem(name: String) {
        let newItem = ShoppingListItem(name: name)
        shoppingItems.append(newItem)
    }
    
    func toggleDeclutterTodo(_ id: UUID) {
        if let index = declutterTodos.firstIndex(where: { $0.id == id }) {
            declutterTodos[index].isChecked.toggle()
        }
    }
}
