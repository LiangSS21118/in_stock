import Foundation

extension String {
    var trimmedForUserInput: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
