import Foundation

struct Achievement: Identifiable {
    let id: UUID
    var title: String
    var value: Double
    var unit: String
    var iconName: String
    
    init(id: UUID = UUID(), title: String, value: Double, unit: String, iconName: String) {
        self.id = id
        self.title = title
        self.value = value
        self.unit = unit
        self.iconName = iconName
    }
}
