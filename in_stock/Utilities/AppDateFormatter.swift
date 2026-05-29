import Foundation

enum AppDateFormatter {
    static func fullDateString(from date: Date) -> String {
        fullDateFormatter.string(from: date)
    }

    static func shortMonthDayString(from date: Date) -> String {
        shortMonthDayFormatter.string(from: date)
    }

    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    private static let shortMonthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter
    }()
}
