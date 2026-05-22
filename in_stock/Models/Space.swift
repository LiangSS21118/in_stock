import Foundation

struct Space: Identifiable {
    let id: UUID
    var name: String
    var illustrationName: String
    var asciiArtText: String
    var items: [Item]
    
    init(id: UUID = UUID(), name: String, illustrationName: String, asciiArtText: String, items: [Item] = []) {
        self.id = id
        self.name = name
        self.illustrationName = illustrationName
        self.asciiArtText = asciiArtText
        self.items = items
    }
}
