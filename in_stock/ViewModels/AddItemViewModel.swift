import SwiftUI
import Foundation
import Combine

@MainActor
class AddItemViewModel: ObservableObject {
    // Input state
    @Published var inputText: String = ""
    @Published var itemName: String = ""
    @Published var quantity: Double = 1.0
    @Published var unit: String = "瓶"
    @Published var expiryDate: Date = Date()
    @Published var selectedSpaceId: UUID = UUID()
    @Published var locationText: String = "冰箱"
    @Published var isConsumable: Bool = true
    @Published var reminderThreshold: Double = 0.2
    
    @Published var isParsing: Bool = false
    @Published var isRecognizing: Bool = false
    
    private(set) var spaces: [Space]
    
    init(spaces: [Space]) {
        self.spaces = spaces
        if let firstSpaceId = spaces.first?.id {
            self.selectedSpaceId = firstSpaceId
        }
    }
    
    func syncSpaces(_ spaces: [Space]) {
        self.spaces = spaces

        if !spaces.contains(where: { $0.id == selectedSpaceId }), let firstSpaceId = spaces.first?.id {
            selectedSpaceId = firstSpaceId
        }
    }

    func preselectSpace(_ spaceId: UUID) {
        guard spaces.contains(where: { $0.id == spaceId }) else { return }
        selectedSpaceId = spaceId
    }

    // Step 1: Mock NLP
    func parseNaturalLanguage(completion: (() -> Void)? = nil) {
        isParsing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isParsing = false
            if self.inputText.contains("牛奶") {
                self.itemName = "牛奶"
                self.quantity = 3.0
                self.unit = "瓶"
                self.expiryDate = self.nextFutureDate(month: 5, day: 2)
                self.locationText = "冰箱"
                if let kitchen = self.spaces.first(where: { $0.name == "廚房" }) {
                    self.selectedSpaceId = kitchen.id
                }
            } else {
                self.itemName = self.inputText
                self.expiryDate = Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date()
            }
            completion?()
        }
    }
    
    // Step 2: Mock Camera AI
    func mockCameraRecognition(completion: (() -> Void)? = nil) {
        isRecognizing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isRecognizing = false
            self.itemName = "林鳳營鮮乳"
            self.quantity = 1.0
            self.unit = "瓶"
            self.expiryDate = self.nextFutureDate(month: 5, day: 2)
            self.locationText = "冰箱"
            if let kitchen = self.spaces.first(where: { $0.name == "廚房" }) {
                self.selectedSpaceId = kitchen.id
            }
            completion?()
        }
    }
    
    func reset(defaultSpaceId: UUID? = nil) {
        inputText = ""
        itemName = ""
        quantity = 1.0
        unit = "瓶"
        expiryDate = Date()
        if let defaultSpaceId {
            selectedSpaceId = defaultSpaceId
        } else if let firstSpaceId = spaces.first?.id {
            selectedSpaceId = firstSpaceId
        }
        locationText = "冰箱"
        isConsumable = true
        reminderThreshold = 0.2
    }

    private func nextFutureDate(month: Int, day: Int) -> Date {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        var components = DateComponents()
        components.year = currentYear
        components.month = month
        components.day = day

        let startOfToday = calendar.startOfDay(for: now)
        guard let dateThisYear = calendar.date(from: components) else {
            return now
        }

        if calendar.startOfDay(for: dateThisYear) >= startOfToday {
            return dateThisYear
        }

        components.year = currentYear + 1
        return calendar.date(from: components) ?? now
    }
}
