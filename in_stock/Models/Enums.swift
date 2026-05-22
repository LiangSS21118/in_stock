import Foundation

enum ItemStatus: String, CaseIterable {
    case inStock = "在庫"
    case lowStock = "低庫存"
    case expiringSoon = "即將到期"
    case expired = "已到期"
}

enum ItemCategory: String, CaseIterable {
    case consumable = "耗材"
    case nonConsumable = "非耗材"
}

enum ReminderType: String, CaseIterable {
    case lowStock = "低庫存"
    case expiringSoon = "即將到期"
    case shoppingMode = "購物模式"
    case declutter = "斷捨離"
    case push = "推播通知"
}

enum ListMode: String, CaseIterable {
    case checklist = "清單模式"
    case shopping = "購物模式"
}

enum DeclutterAction: String, CaseIterable {
    case donate = "捐贈"
    case sellSecondHand = "二手出售"
    case discard = "丟棄"
}

enum AppTab {
    case home
    case spaces
    case add
    case lists
    case settings
}
