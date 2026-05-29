# Source Code 導讀

這份文件整理 `in_stock` 專案的主要架構、資料流、畫面組成與目前值得注意的技術債。專案目前是一個純 SwiftUI、mock data driven 的 iOS app，主題是家庭庫存、購物清單、到期提醒與斷捨離管理。

## 整體架構

專案主要分成：

- `in_stock/`：App source code。
- `in_stock/Models/`：資料型別。
- `in_stock/ViewModels/`：畫面狀態與操作邏輯。
- `in_stock/Views/`：各功能畫面。
- `in_stock/Components/`：共用 SwiftUI 元件。
- `in_stock/Data/MockData.swift`：所有假資料。
- `in_stock/Theme/AppTheme.swift`：共用顏色、字體、卡片樣式。
- `blueprint/`：設計參考圖。

目前沒有 test target，也沒有後端、資料庫、網路層或持久化庫存資料。登入狀態使用 `@AppStorage`，其他 app 狀態都存在記憶體中的 ViewModel。

## App 入口與根路由

入口在 `in_stock/in_stockApp.swift`。`InStockApp` 建立兩個全域狀態物件：

```swift
@StateObject var authViewModel = AuthViewModel()
@StateObject var appViewModel = AppViewModel()
```

並透過 `.environmentObject(...)` 注入到 `RootView`。

`Views/Root/RootView.swift` 是第一層流程控制：

- `authViewModel.isLoggedIn == true`：進入 `MainContainerView`。
- 否則顯示 `LoginView`。

`Views/Root/MainContainerView.swift` 是登入後的主容器，用 `appViewModel.selectedTab` 決定目前畫面：

- `.home`：Dashboard。
- `.spaces`：空間列表。
- `.add`：新增物品入口。
- `.lists`：清單。
- `.settings`：個人頁。

底部 tab bar 是 `Components/CustomTabBar.swift`，中間有浮動 `+` 按鈕，點擊後切到 `.add`。

## 資料模型

核心 enum 在 `Models/Enums.swift`：

- `ItemStatus`：在庫、低庫存、即將到期、已到期。
- `ReminderType`：低庫存、即將到期、購物模式、斷捨離、推播。
- `ListMode`：清單模式、購物模式。
- `DeclutterAction`：捐贈、二手出售、丟棄。
- `AppTab`：底部 tab 狀態。

核心庫存模型是 `Models/Item.swift`。它包含：

- `name`、`imageName`：顯示名稱與 emoji 圖示。
- `quantity`、`unit`：數量與單位。
- `remainingPercentage`：剩餘比例。
- `expiryDate`：到期日。
- `spaceId`：所屬空間。
- `locationText`：空間內位置文字。
- `isConsumable`：是否耗材。
- `reminderThreshold`：提醒門檻。
- `status`：庫存狀態。

其他模型都很薄：

- `Space`：空間分類，包含 ASCII art 與 `items` 欄位。
- `ShoppingListItem`：購物清單項目。
- `DeclutterItem`：斷捨離項目。
- `NotificationItem`：提醒中心通知。
- `Achievement`：個人成就。
- `User`：使用者資料。

要注意：`Space` 裡雖然有 `items: [Item]`，但目前實際邏輯沒有用它儲存物品。真正的庫存清單在 `AppViewModel.items`，再用 `spaceId` 過濾。

## MockData

所有初始資料集中在 `Data/MockData.swift`。

它提供：

- 使用者：`currentUser`。
- 空間：廚房、客廳、臥室、浴室。
- 庫存品項：牛奶、吐司、雞蛋、洗衣精、衛生紙等。
- 購物清單：牛奶、雞蛋、洗衣精、牙膏。
- 斷捨離項目：米色大衣、相機、運動鞋、加濕器。
- 通知：牛奶到期、洗衣精低庫存、斷捨離待辦。
- 成就：斷捨離件數、騰出空間、持續天數。

這裡有一個重要特性：`spaces`、`items`、`shoppingItems` 等都是 computed property，每次取用都會重新產生資料。`MockData.shared` 本身不是資料庫，只是資料工廠。

## ViewModel 導讀

`AuthViewModel` 管登入狀態：

- `@AppStorage("isLoggedIn")`
- `@AppStorage("currentUserName")`
- `@AppStorage("currentUserEmail")`
- `login(...)` 和 `register(...)` 都是 mock delay。
- 只檢查欄位是否為空，沒有真正驗證帳密。
- `logout()` 清掉登入狀態與使用者欄位。

`AppViewModel` 是 app 的主要狀態中心：

- `selectedTab`
- `currentUser`
- `spaces`
- `items`
- `notifications`
- `declutterItems`
- `achievements`

Dashboard 用的 computed properties 也在這裡：

- `lowStockItems`
- `expiringSoonItems`
- `shoppingListCount`
- `declutterTodoCount`

它也提供基本 CRUD：

- `addItem`
- `updateItem`
- `deleteItem`
- `itemsForSpace`

目前 `shoppingListCount` 直接讀 `MockData.shared.shoppingItems.count`，不是跟 `ListViewModel.shoppingItems` 同步，所以清單頁如果改動購物清單，Dashboard 數字不會跟著變。

`ListViewModel` 是清單頁局部狀態：

- `selectedMode`
- `shoppingItems`
- `declutterTodos`
- progress 字串。
- toggle checked。
- 更新購物品項數量。
- 新增購物品項。

它是由 `ListView` 用 `@StateObject` 自己建立，所以它不是 app-wide 狀態。

`AddItemViewModel` 管新增物品流程：

- 輸入文字、品名、數量、單位、到期日、空間、是否耗材。
- `parseNaturalLanguage()` mock 自然語言解析。
- `mockCameraRecognition()` mock 相機辨識。
- `reset()`。

目前解析邏輯只特別處理文字包含「牛奶」的情境；相機辨識固定輸出「林鳳營鮮乳」。兩者都把到期日寫成 2024/05/02，這在目前日期下已經是過去日期，但 UI 還是會照樣顯示。

## 主要畫面流程

### 登入頁

相關檔案：

- `Views/Auth/LoginView.swift`
- `Views/Auth/RegisterView.swift`

`LoginView` 用 `@StateObject var viewModel: AuthViewModel` 接收外部傳入的 `AuthViewModel`，這種寫法比較不典型；因為它不是自己擁有的 model，通常會用 `@ObservedObject`。不過目前功能上可運作。

### Dashboard

相關檔案：

- `Views/Dashboard/DashboardView.swift`
- `Views/Dashboard/ReminderCenterView.swift`

Dashboard 顯示：

- 歡迎使用者。
- 統計卡片：購物清單、斷捨離清單、低庫存、即將過期。
- 橫向低庫存物品。
- 橫向即將到期物品。
- 提醒中心通知。

物品卡用 `Components/StickerItemCard.swift`。

### 空間頁

相關檔案：

- `Views/Spaces/SpaceView.swift`
- `Views/Spaces/SpaceDetailView.swift`

`SpaceView` 顯示空間 grid。每個空間點進去後，`SpaceDetailView` 透過：

```swift
viewModel.itemsForSpace(space.id)
```

從全域 `items` 過濾該空間的物品。

「新增空間分類」按鈕目前是空 action。空間詳情裡「新增物品」會切到 `.add` tab，但沒有把目前 space 預選帶入新增流程。

### 新增物品

相關檔案：

- `Views/AddItem/AddItemEntryView.swift`
- `Views/AddItem/NaturalLanguageInputView.swift`
- `Views/AddItem/CameraRecognitionView.swift`
- `Views/AddItem/AddItemConfirmView.swift`

流程是：

1. 進入新增入口，選自然語言或相機。
2. mock 解析或 mock 辨識。
3. 進入確認表單。
4. 點「新增到庫存」。
5. 建立 `Item`。
6. 呼叫 `appViewModel.addItem(newItem)`。
7. 切回首頁。

關鍵新增邏輯在 `AddItemConfirmView`。目前新增後沒有呼叫 `viewModel.reset()`，所以如果下一次再進入新增流程，可能保留上一次輸入狀態，因為 `AddItemEntryView` 持有的是 `@StateObject`。

### 清單頁

相關檔案：

- `Views/Lists/ListView.swift`
- `Views/Lists/ChecklistModeView.swift`
- `Views/Lists/ShoppingModeView.swift`

`ListView` 內建 segmented control，切換：

- 清單模式：購物清單卡、斷捨離待辦卡、建議購入、建議斷捨離。
- 購物模式：購物清單 row，可勾選與調整數量。

「新增品項」按鈕目前是空 action。元件 `QuantityStepper` 已存在，但購物模式目前是直接手寫 plus/minus button，沒有使用這個共用元件。

### 斷捨離頁

相關檔案：

- `Views/Declutter/DeclutterView.swift`
- `Views/Declutter/DeclutterDetailView.swift`
- `Views/Declutter/DeclutterSettingsView.swift`

這組畫面本身完整，但目前沒有被 `MainContainerView` 的 tab switch 接上，所以一般使用者從 app 主流程進不到 `DeclutterView`。只有 Dashboard 顯示斷捨離統計，List 顯示一些斷捨離待辦。

### Profile

相關檔案：

- `Views/Profile/ProfileView.swift`
- `Views/Profile/AchievementView.swift`

Profile 顯示目前登入名稱、email、設定列、登出按鈕，以及成就卡。登出後 `RootView` 會因 `isLoggedIn` 變成 false 回到登入頁。

## 共用元件與樣式

Theme 在 `Theme/AppTheme.swift`，定義：

- 米白背景。
- 白色卡片。
- 黑灰文字。
- 低庫存、即將到期、正常狀態顏色。
- 20pt corner radius。
- rounded system fonts。
- `stickerStyle()`。
- `cardStyle()`。

主要共用元件：

- `PrimaryButton`：黑底主按鈕。
- `AuthTextField`：登入與表單輸入。
- `CustomTabBar`：底部 tab bar。
- `StatCard`：Dashboard 統計卡。
- `StickerItemCard`：物品小卡。
- `SpaceCard`：空間卡。
- `PaperChecklistCard`：紙張風清單卡。
- `NotificationCard`：提醒中心通知卡。
- `StatusBadge`：狀態膠囊。
- `AddPlaceholderCard`：虛線新增卡。
- `SectionHeader`：區塊標題。
- `QuantityStepper`：數量加減器，目前未被使用。

## Xcode Project 狀態

`in_stock.xcodeproj` 目前只有一個 native target：`in_stock`。

設定重點：

- `PRODUCT_BUNDLE_IDENTIFIER = tw.edu.fcu.d1321264.in-stock`
- `SWIFT_VERSION = 5.0`
- `IPHONEOS_DEPLOYMENT_TARGET = 26.5`
- 沒看到測試 target。
- `ContentView.swift` 仍是 Xcode template 的 Hello World，沒有被 app 入口使用。

## 目前值得注意的設計與技術債

1. `DeclutterView` 尚未接入主導航。
   `AppTab` 沒有 declutter tab，`MainContainerView` 也沒有 route 到它。

2. Dashboard 的購物清單數量不是 live state。
   `AppViewModel.shoppingListCount` 讀 `MockData.shared.shoppingItems.count`，不會反映 `ListViewModel` 的修改。

3. 新增物品流程不會重置表單。
   成功新增後只切回首頁，沒有 reset `AddItemViewModel`。

4. 部分按鈕尚未實作。
   例如新增空間、購物清單新增品項、斷捨離新增項目、儲存斷捨離設定。

5. 資料分散在 mock 與多個 ViewModel。
   庫存資料在 `AppViewModel`，購物清單在 `ListViewModel`，兩者沒有同步來源。之後若要接資料庫，建議抽一層 repository 或 store。

6. 日期 mock 已過期。
   新增流程和通知文字使用 2024/05/02 或 5/2，現在會顯得不合理。

7. `Space.items` 欄位目前實際沒用。
   真正物品歸屬是 `Item.spaceId`。建議保留一種資料關聯方式即可。

8. `LoginView` 對外部傳入 ViewModel 使用 `@StateObject`。
   語意上較適合 `@ObservedObject`，因為生命週期是由 app root 建立並注入。

## 總結

整體來看，這是一個完成度偏 prototype / UI mock 的 SwiftUI app：畫面與資料模型已經鋪好，使用者可走登入、Dashboard、空間、清單、新增物品、個人頁等主要流程；下一階段的重點會是把 mock state 收斂成單一資料來源、補齊未實作 actions、接上斷捨離主流程，然後再加測試與持久化。
