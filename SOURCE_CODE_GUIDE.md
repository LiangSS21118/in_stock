# Source Code 導讀

這份文件整理 `in_stock` 專案的主要架構、資料流、畫面組成與目前值得注意的技術債。專案目前是一個純 SwiftUI、mock data driven 的 iOS app prototype，主題是家庭庫存、購物清單、到期提醒與斷捨離管理。

## 整體架構

專案主要分成：

- `in_stock/`：App source code。
- `in_stock/Models/`：資料型別。
- `in_stock/ViewModels/`：畫面狀態與操作邏輯。
- `in_stock/Views/`：各功能畫面。
- `in_stock/Components/`：共用 SwiftUI 元件。
- `in_stock/Data/MockData.swift`：所有假資料。
- `in_stock/Theme/AppTheme.swift`：共用顏色、字體、卡片樣式。
- `in_stock/Utilities/`：跨功能的小型 helper，例如日期格式與使用者輸入整理。
- `blueprint/`：設計參考圖與圖片索引，詳見 `blueprint/README.md`。

主要專案文件：

- `README.md`：專案定位、功能概覽、建置方式與目前狀態。
- `SOURCE_CODE_GUIDE.md`：目前這份 source code、資料流與技術債導讀。
- `BLUEPRINT_IMPLEMENTATION_REPORT.md`：blueprint 對照、完成度與偏差報告。
- `GEMINI.md`：AI assistant 使用的英文專案摘要，內容需和 README / source guide 保持一致。

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

內容區域下方墊有約 90pt 的 padding 以確保內容不被底部 tab bar 遮擋，特別是清單頁的「購物完畢」固定按鈕。

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
- `createdAt`：建立時間。

其他模型：
- `Space`：空間分類，包含 icon name 與 ASCII placeholder art。
- `ShoppingListItem`：購物清單項目。
- `ShoppingRestockEntry`：購物完畢後的回補預覽模型。
- `DeclutterItem`：斷捨離項目。
- `NotificationItem`：提醒中心通知。
- `Achievement`：個人成就統計。
- `User`：使用者資料。

空間與物品的關聯只有一個來源：真正的庫存清單在 `AppViewModel.items`，並透過 `Item.spaceId` 過濾到對應空間。`Space` 不再保存自己的 item array，避免和 app-wide inventory state 產生雙重來源。

## MockData

所有初始資料集中在 `Data/MockData.swift`。

它提供：
- 使用者：`currentUser`。
- 空間：廚房、客廳、臥室、浴室。
- 庫存品項：牛奶、吐司、雞蛋、洗衣精、衛生紙等。
- 購物清單：牛奶、雞蛋、洗衣精、牙膏。
- 斷捨離待辦：玄關備用傘、重複購買的馬克杯。
- 斷捨離項目：米色大衣、相機、運動鞋、加濕器。
- 已完成斷捨離項目：提供 8 項預設已完成項目用於成就展示。
- 通知：牛奶到期、洗衣精低庫存、斷捨離待辦。
- 成就統計：斷捨離件數、騰出空間、持續天數。

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
- `selectedListMode`
- `isShoppingFocusActive`
- `currentUser`
- `spaces`
- `items`
- `shoppingItems`
- `declutterTodos`
- `notifications`
- `declutterItems`
- `doneDeclutterItems`：展示在成就頁面的已完成項目。
- `achievements`
- `pendingAddSpaceId`
- `searchText`：通用搜尋文字，用於庫存過濾與清單搜尋。

Dashboard 用的 computed properties 也在這裡：
- `lowStockItems`
- `expiringSoonItems`
- `filteredItems`：根據搜尋文字過濾後的庫存。
- `filteredShoppingItems`：根據搜尋文字過濾後的購物清單。
- `shoppingListCount`
- `declutterTodoCount`
- `shoppingProgress`
- `declutterProgress`

它也提供主要 mock state 操作：
- `addItem` / `updateItem` / `deleteItem`
- `itemsForSpace`
- `startAddingItem(in:)`
- `status(for:remainingPercentage:reminderThreshold:)`：動態計算物品狀態。
- `addSpace(name:)`：自動生成對應的 ASCII art。
- `startShoppingMode` / `pauseShoppingMode` / `finishShoppingMode`
- `toggleShoppingItem` / `setShoppingItemQuantity`
- `addShoppingItem`：支持名稱匹配遞增。
- `addLowStockItemToShoppingList`：支持 `sourceItemId` 關聯。
- `restockEntriesForCompletedShoppingItems`：產生回補預覽與自動匹配。
- `restockFromCompletedShoppingItems`：執行庫存回補與新物品新增。
- `addDeclutterItem` / `updateDeclutterSettings`

購物清單與斷捨離待辦已收斂到 `AppViewModel`，Dashboard 的統計數字與清單頁會讀同一份 live state。清單與購物模式的勾選、數量調整、以及購物完畢後的回補流程都經由 `AppViewModel` 方法更新。

`AddItemViewModel` 管新增物品流程：
- 輸入文字、品名、數量、單位、到期日、空間、位置、是否耗材、提醒門檻。
- `parseNaturalLanguage()` mock 自然語言解析。
- `mockCameraRecognition()` mock 相機辨識。
- `reset()`。

## 主要畫面流程

### 登入頁

相關檔案：
- `Views/Auth/LoginView.swift`
- `Views/Auth/RegisterView.swift`

### Dashboard

相關檔案：
- `Views/Dashboard/DashboardView.swift`
- `Views/Dashboard/ReminderCenterView.swift`

顯示統計、購物入口、快用完與即將過期列表、以及提醒中心。購物入口會根據 `isShoppingFocusActive` 動態切換顯示文字。

### 空間頁

相關檔案：
- `Views/Spaces/SpaceView.swift`
- `Views/Spaces/SpaceDetailView.swift`

`SpaceView` 支援搜尋，搜尋時顯示物品 grid，平時顯示空間 grid。`SpaceDetailView` 顯示特定空間的所有物品。

### 新增物品

相關檔案：
- `Views/AddItem/AddItemEntryView.swift`
- `Views/AddItem/AddItemConfirmView.swift`等

流程包含自然語言/相機入口與確認表單。確認表單已優化為 compact row layout。

### 清單頁

相關檔案：
- `Views/Lists/ListView.swift`
- `Views/Lists/ShoppingModeView.swift`
- `Views/Lists/RestockConfirmationView.swift`等

支持清單與購物兩種模式。購物模式下可開啟「專注狀態」。支援搜尋庫存物品加入。購物完畢後會跳出回補確認視窗。

### 斷捨離頁

相關檔案：
- `Views/Declutter/DeclutterView.swift`
- `Views/Declutter/DeclutterSettingsView.swift`

管理待處理的斷捨離項目，並可設定處理細節。

### Profile & 成就

相關檔案：
- `Views/Profile/ProfileView.swift`
- `Views/Profile/AchievementView.swift`

Profile 提供帳戶設定。`AchievementView` 使用貼紙卡 grid 展示已完成的斷捨離項目，並配有 ASCII 獎盃 header。

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
- `QuantityStepper`：數量加減器，用於購物模式與新增物品確認表單。

跨功能 helper 在 `Utilities/`：

- `AppDateFormatter`：集中 `yyyy/MM/dd` 與 `M/d` 兩種目前 UI 需要的日期格式，避免各 View 重複建立 formatter。
- `String.trimmedForUserInput`：集中表單輸入 trim 規則，讓新增空間、購物品項、斷捨離項目與新增物品流程使用同一套空白處理。

## Xcode Project 狀態

`in_stock.xcodeproj` 目前只有一個 native target：`in_stock`。

設定重點：

- `PRODUCT_BUNDLE_IDENTIFIER = tw.edu.fcu.d1321264.in-stock`
- `SWIFT_VERSION = 5.0`
- `IPHONEOS_DEPLOYMENT_TARGET = 26.5`
- 沒看到測試 target。
- `ContentView.swift` 已改為 preview-friendly root wrapper，app 入口仍使用 `InStockApp` 注入全域狀態。

## 目前值得注意的設計與技術債

1. 視覺資產仍未完整導入。
   商品貼紙與空間線稿仍主要以 emoji / ASCII / SF Symbols 暫代，和設計稿的實物圖與線稿還有距離。

2. 自然語言與相機辨識仍是 mock。
   目前只覆蓋少數固定結果，尚未接真實 NLP、camera session 或 OCR。

3. App state 尚未持久化。
   `AppViewModel` 已收斂主要 mock state，但資料重啟後仍會回到 `MockData` 初始值。

4. 尚未建立 test target。
   建議下一步補 XCTest target，優先測 `AppViewModel` 的新增、更新與清單操作。

近期已清理的技術債：

- 移除未使用的 `Space.items`，保留 `AppViewModel.items` + `Item.spaceId` 作為唯一庫存關聯。
- 將重複的 `DateFormatter` 建立集中到 `AppDateFormatter`。
- 將使用者輸入 trim 規則集中到 `String.trimmedForUserInput`。
- 將購物模式的 row 勾選與數量調整收斂到 `AppViewModel` 方法。

## 總結

整體來看，這是一個完成度偏 prototype / UI mock 的 SwiftUI app：畫面與資料模型已經鋪好，使用者可走登入、Dashboard、空間、清單、新增物品、斷捨離、個人頁等主要流程。主要 app state 已集中在 `AppViewModel`，空間與庫存關聯也已收斂到單一資料來源；下一階段的重點會是導入視覺資產、加入持久化、替換 mock 辨識流程，然後補測試。
