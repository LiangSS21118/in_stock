import Foundation

struct NotificationItem: Identifiable {
    let id: UUID
    var title: String
    var message: String
    var timeText: String
    var type: ReminderType
    
    init(id: UUID = UUID(), title: String, message: String, timeText: String, type: ReminderType) {
        self.id = id
        self.title = title
        self.message = message
        self.timeText = timeText
        self.type = type
    }
}
