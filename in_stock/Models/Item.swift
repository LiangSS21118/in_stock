import Foundation

struct Item: Identifiable, Equatable {
    let id: UUID
    var name: String
    var imageName: String
    var quantity: Double
    var unit: String
    var remainingPercentage: Double // 0.0 to 1.0
    var expiryDate: Date?
    var spaceId: UUID
    var locationText: String
    var isConsumable: Bool
    var reminderThreshold: Double // percentage, e.g., 0.2
    var status: ItemStatus
    var createdAt: Date
    
    init(id: UUID = UUID(), 
         name: String, 
         imageName: String, 
         quantity: Double, 
         unit: String, 
         remainingPercentage: Double, 
         expiryDate: Date? = nil, 
         spaceId: UUID, 
         locationText: String, 
         isConsumable: Bool, 
         reminderThreshold: Double = 0.2, 
         status: ItemStatus = .inStock, 
         createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.quantity = quantity
        self.unit = unit
        self.remainingPercentage = remainingPercentage
        self.expiryDate = expiryDate
        self.spaceId = spaceId
        self.locationText = locationText
        self.isConsumable = isConsumable
        self.reminderThreshold = reminderThreshold
        self.status = status
        self.createdAt = createdAt
    }
}
