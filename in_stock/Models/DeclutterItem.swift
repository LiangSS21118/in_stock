import Foundation

struct DeclutterItem: Identifiable {
    let id: UUID
    var name: String
    var imageName: String
    var locationText: String
    var createdAt: Date
    var action: DeclutterAction
    var reason: String
    var lastUsedDate: Date?
    var reminderCycle: String // e.g., "3 個月"
    var futureMessage: String

    init(id: UUID = UUID(),
         name: String,
         imageName: String,
         locationText: String,
         createdAt: Date = Date(),
         action: DeclutterAction,
         reason: String = "",
         lastUsedDate: Date? = nil,
         reminderCycle: String = "3 個月",
         futureMessage: String = "") {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.locationText = locationText
        self.createdAt = createdAt
        self.action = action
        self.reason = reason
        self.lastUsedDate = lastUsedDate
        self.reminderCycle = reminderCycle
        self.futureMessage = futureMessage
    }
}
