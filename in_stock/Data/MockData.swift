import Foundation

struct MockData {
    static let shared = MockData()
    
    let currentUser = User(name: "使用者", email: "user@example.com", avatarName: "person.circle.fill")
    
    let kitchenId = UUID()
    let livingRoomId = UUID()
    let bedroomId = UUID()
    let bathroomId = UUID()
    
    var spaces: [Space] {
        [
            Space(id: kitchenId, name: "廚房", illustrationName: "fork.knife", asciiArtText: """
                 [  ]  [  ]
                 |__|__|__|
                 |        |
                 |________|
                 """),
            Space(id: livingRoomId, name: "客廳", illustrationName: "tv", asciiArtText: """
                  _______
                 |       |
                 |  [ ]  |
                 |_______|
                  /     \\
                 """),
            Space(id: bedroomId, name: "臥室", illustrationName: "bed.double", asciiArtText: """
                  ________
                 |  ____  |
                 | |    | |
                 |_|____|_|
                 """),
            Space(id: bathroomId, name: "浴室", illustrationName: "bathtub", asciiArtText: """
                  .----.
                 |      |
                 '------'
                 """)
        ]
    }
    
    var items: [Item] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            Item(name: "牛奶", imageName: "🥛", quantity: 1, unit: "瓶", remainingPercentage: 0.8, expiryDate: calendar.date(byAdding: .day, value: 2, to: today), spaceId: kitchenId, locationText: "冰箱", isConsumable: true, status: .expiringSoon),
            Item(name: "吐司", imageName: "🍞", quantity: 1, unit: "包", remainingPercentage: 0.5, expiryDate: calendar.date(byAdding: .day, value: 3, to: today), spaceId: kitchenId, locationText: "麵包籃", isConsumable: true, status: .expiringSoon),
            Item(name: "雞蛋", imageName: "🥚", quantity: 6, unit: "顆", remainingPercentage: 0.6, expiryDate: calendar.date(byAdding: .day, value: 2, to: today), spaceId: kitchenId, locationText: "冰箱", isConsumable: true, status: .expiringSoon),
            Item(name: "洗衣精", imageName: "🧴", quantity: 1, unit: "瓶", remainingPercentage: 0.2, spaceId: bathroomId, locationText: "層架", isConsumable: true, status: .lowStock),
            Item(name: "衛生紙", imageName: "🧻", quantity: 2, unit: "捲", remainingPercentage: 0.1, spaceId: bathroomId, locationText: "櫥櫃", isConsumable: true, status: .lowStock),
            Item(name: "沙拉油", imageName: "🍾", quantity: 1, unit: "瓶", remainingPercentage: 0.7, spaceId: kitchenId, locationText: "櫥櫃", isConsumable: true),
            Item(name: "花生醬", imageName: "🥜", quantity: 1, unit: "罐", remainingPercentage: 0.3, spaceId: kitchenId, locationText: "層架", isConsumable: true),
            Item(name: "白米", imageName: "🍚", quantity: 5, unit: "kg", remainingPercentage: 0.6, spaceId: kitchenId, locationText: "儲藏室", isConsumable: true),
            Item(name: "咖啡豆", imageName: "☕️", quantity: 1, unit: "包", remainingPercentage: 0.4, spaceId: kitchenId, locationText: "咖啡角", isConsumable: true)
        ]
    }
    
    var shoppingItems: [ShoppingListItem] {
        [
            ShoppingListItem(name: "牛奶", quantity: 1),
            ShoppingListItem(name: "雞蛋", quantity: 1),
            ShoppingListItem(name: "洗衣精", quantity: 1),
            ShoppingListItem(name: "牙膏", quantity: 1)
        ]
    }

    var declutterTodos: [ShoppingListItem] {
        [
            ShoppingListItem(name: "玄關備用傘", isChecked: false),
            ShoppingListItem(name: "重複購買的馬克杯", isChecked: true)
        ]
    }
    
    var declutterItems: [DeclutterItem] {
        [
            DeclutterItem(name: "米色大衣", imageName: "🧥", locationText: "衣櫃 / 掛衣區", action: .donate, reason: "很少使用"),
            DeclutterItem(name: "相機 Canon EOS M50", imageName: "📷", locationText: "書房 / 收納櫃", action: .sellSecondHand, reason: "重複擁有"),
            DeclutterItem(name: "白色運動鞋", imageName: "👟", locationText: "玄關 / 鞋櫃", action: .donate, reason: "不再喜歡"),
            DeclutterItem(name: "加濕器", imageName: "💧", locationText: "客廳 / 櫃子", action: .discard, reason: "損壞")
        ]
    }

    var doneDeclutterItems: [DeclutterItem] {
        [
            DeclutterItem(name: "老舊筆電", imageName: "💻", locationText: "回收中心", action: .discard, reason: "已報廢"),
            DeclutterItem(name: "過期雜誌", imageName: "📚", locationText: "回收桶", action: .discard, reason: "資訊過時"),
            DeclutterItem(name: "不再穿的 T-shirt", imageName: "👕", locationText: "舊衣回收箱", action: .donate, reason: "斷捨離成功"),
            DeclutterItem(name: "多餘的餐具", imageName: "🍴", locationText: "二手市集", action: .sellSecondHand, reason: "簡約生活"),
            DeclutterItem(name: "壞掉的手錶", imageName: "⌚️", locationText: "垃圾桶", action: .discard, reason: "無法修理"),
            DeclutterItem(name: "不常用的包包", imageName: "👜", locationText: "贈送給朋友", action: .donate, reason: "延續價值"),
            DeclutterItem(name: "多餘的馬克杯", imageName: "🥛", locationText: "二手店", action: .sellSecondHand, reason: "清空桌面"),
            DeclutterItem(name: "舊手機", imageName: "📱", locationText: "回收計畫", action: .discard, reason: "回收利用")
        ]
    }
    
    var notifications: [NotificationItem] {
        let milkExpiryText = shortDateString(daysFromToday: 2)

        return [
            NotificationItem(title: "牛奶即將到期", message: "牛奶將於 \(milkExpiryText) 到期，請盡快飲用。", timeText: "現在", type: .expiringSoon),
            NotificationItem(title: "庫存不足提醒", message: "洗衣精快用完了，剩餘約 20%。", timeText: "上午 9:00", type: .lowStock),
            NotificationItem(title: "斷捨離待辦", message: "你有 2 項斷捨離待辦項目需要處理。", timeText: "昨天", type: .declutter)
        ]
    }
    
    var achievements: [Achievement] {
        [
            Achievement(title: "已斷捨離件數", value: 128, unit: "件", iconName: "trash"),
            Achievement(title: "騰出空間", value: 2.4, unit: "m³", iconName: "square.dashed"),
            Achievement(title: "持續天數", value: 45, unit: "天", iconName: "calendar")
        ]
    }

    private func shortDateString(daysFromToday days: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: days, to: Date()) ?? Date()
        return AppDateFormatter.shortMonthDayString(from: date)
    }
}
