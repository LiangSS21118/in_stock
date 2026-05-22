import SwiftUI
import Combine
import Foundation

@MainActor
class AddItemViewModel: ObservableObject {
    // Input state
    @Published var inputText: String = ""
    @Published var itemName: String = ""
    @Published var quantity: Double = 1.0
    @Published var unit: String = "瓶"
    @Published var expiryDate: Date = Date()
    @Published var selectedSpaceId: UUID = UUID()
    @Published var isConsumable: Bool = true
    @Published var reminderThreshold: Double = 0.2
    
    @Published var isParsing: Bool = false
    @Published var isRecognizing: Bool = false
    
    let spaces: [Space]
    
    init(spaces: [Space]) {
        self.spaces = spaces
        if let firstSpaceId = spaces.first?.id {
            self.selectedSpaceId = firstSpaceId
        }
    }
    
    // Step 1: Mock NLP
    func parseNaturalLanguage() {
        isParsing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isParsing = false
            if self.inputText.contains("牛奶") {
                self.itemName = "牛奶"
                self.quantity = 3.0
                self.unit = "瓶"
                // Mock 5/2 date
                var components = DateComponents()
                components.year = 2024
                components.month = 5
                components.day = 2
                self.expiryDate = Calendar.current.date(from: components) ?? Date()
            } else {
                self.itemName = self.inputText
            }
        }
    }
    
    // Step 2: Mock Camera AI
    func mockCameraRecognition() {
        isRecognizing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isRecognizing = false
            self.itemName = "林鳳營鮮乳"
            self.quantity = 1.0
            self.unit = "瓶"
            var components = DateComponents()
            components.year = 2024
            components.month = 5
            components.day = 2
            self.expiryDate = Calendar.current.date(from: components) ?? Date()
            // Assume Kitchen
            if let kitchen = self.spaces.first(where: { $0.name == "廚房" }) {
                self.selectedSpaceId = kitchen.id
            }
        }
    }
    
    func reset() {
        inputText = ""
        itemName = ""
        quantity = 1.0
        unit = "瓶"
        expiryDate = Date()
        isConsumable = true
        reminderThreshold = 0.2
    }
}
