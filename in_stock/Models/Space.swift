import Foundation

struct Space: Identifiable {
    let id: UUID
    var name: String
    var illustrationName: String
    var asciiArtText: String
    
    init(id: UUID = UUID(), name: String, illustrationName: String, asciiArtText: String) {
        self.id = id
        self.name = name
        self.illustrationName = illustrationName
        self.asciiArtText = asciiArtText
    }

    static func placeholderAsciiArt(for name: String) -> String {
        if name.contains("廚") {
            return """
             [  ]  [  ]
             |__|__|__|
             |        |
             |________|
            """
        }

        if name.contains("衣") || name.contains("臥") {
            return """
              ________
             |  ____  |
             | |    | |
             |_|____|_|
            """
        }

        return """
          _______
         |       |
         |  [ ]  |
         |_______|
        """
    }
}
