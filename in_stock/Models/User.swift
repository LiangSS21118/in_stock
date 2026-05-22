import Foundation

struct User: Identifiable {
    let id: UUID
    var name: String
    var email: String
    var avatarName: String
    
    init(id: UUID = UUID(), name: String, email: String, avatarName: String) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarName = avatarName
    }
}
