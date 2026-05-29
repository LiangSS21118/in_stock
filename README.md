# In Stock

`in_stock` 是一個 SwiftUI iOS app prototype，用於管理家中庫存、到期提醒、購物清單、空間分類與斷捨離項目。專案目前以 mock data 驅動畫面，重點放在 app 資訊架構、主要流程與 blueprint 對照驗證。

## 功能概覽

- Mock 登入與註冊流程。
- 首頁 Dashboard：顯示購物模式入口、購物清單、斷捨離、低庫存、即將過期等摘要。
- 提醒中心：低庫存、即將到期、斷捨離待辦等通知卡片。
- 空間管理：以廚房、客廳、臥室、浴室分類展示物品。
- 新增物品：包含自然語言輸入、相機辨識、確認表單與空間預選的 mock 流程。
- 清單：支援清單模式、柔性專注購物模式、數量 stepper、低庫存快速加入與新增購物品項。
- 購物完畢：提供回補確認頁，已匹配項目可回補原庫存（增加數量並重設剩餘比例），未匹配項目可補空間 / 位置或略過。
- 斷捨離：包含清單、詳情、設定儲存與新增項目，支援從 Dashboard 與清單頁快速進入。
- 個人頁：顯示使用者資訊、成就與下一個里程碑。

## 專案結構

```text
in_stock/
├── in_stock/
│   ├── Components/        # Reusable SwiftUI components
│   ├── Data/              # Mock data
│   ├── Models/            # Domain models and enums
│   ├── Theme/             # Shared colors, fonts, and view styles
│   ├── Utilities/         # Shared date formatting and input helpers
│   ├── ViewModels/        # Observable state and mock operations
│   ├── Views/             # Feature views
│   ├── ContentView.swift  # Preview-friendly root wrapper
│   └── in_stockApp.swift  # App entry point
├── blueprint/             # Blueprint reference boards and index
├── in_stock.xcodeproj/    # Xcode project
├── BLUEPRINT_IMPLEMENTATION_REPORT.md
├── SOURCE_CODE_GUIDE.md
├── GEMINI.md
└── README.md
```

## 建置與執行

使用 Xcode 開啟：

```bash
open in_stock.xcodeproj
```

或使用命令列建置：

```bash
xcodebuild -project in_stock.xcodeproj -scheme in_stock -destination 'platform=iOS Simulator,name=iPhone 16' build
```

如果本機沒有 `iPhone 16` simulator，請改用已安裝的 simulator 名稱。

## 目前狀態

專案目前是 UI prototype 階段：

- 尚未接後端、資料庫或真實持久化。
- 登入、自然語言解析、相機辨識皆為 mock。
- 新增空間、購物品項、斷捨離項目、斷捨離設定與購物完畢回補庫存已具備 mock 操作。
- 設計稿中的實物圖片與線稿資產尚未完整導入。
- 尚未建立 XCTest test target。

更多細節請參考：

- [SOURCE_CODE_GUIDE.md](SOURCE_CODE_GUIDE.md)：source code、資料流、主要畫面與技術債導讀。
- [BLUEPRINT_IMPLEMENTATION_REPORT.md](BLUEPRINT_IMPLEMENTATION_REPORT.md)：blueprint 對照、完成度與偏差報告。
- [blueprint/README.md](blueprint/README.md)：設計稿圖片索引、命名規則與對應 app 區域。
- [GEMINI.md](GEMINI.md)：AI assistant 使用的英文專案摘要，內容需和 README / source guide 保持一致。

## 設計稿

`blueprint/` 目錄包含 5 張 app blueprint reference boards，檔名保留原始順序並加入畫面語意：

- `01-dashboard-reminders.png`：首頁 Dashboard / 提醒系統。
- `02-spaces-items.png`：空間 / 物品展示。
- `03-add-item-recognition.png`：新增物品 / 自然語言輸入 / 相機辨識 / 確認表單。
- `04-lists-shopping-mode.png`：清單模式 / 購物模式。
- `05-declutter-profile.png`：斷捨離 / 設定 / Profile 成就。

新增或替換設計稿時，請同步更新 [blueprint/README.md](blueprint/README.md) 與 [BLUEPRINT_IMPLEMENTATION_REPORT.md](BLUEPRINT_IMPLEMENTATION_REPORT.md)。

## 開發注意事項

- App 入口為 `InStockApp`，會注入 `AuthViewModel` 與 `AppViewModel`。
- 主畫面由 `MainContainerView` 透過 `AppTab` 切換。
- 初始資料集中在 `MockData.shared`。
- 目前庫存、購物清單、購物專注狀態、斷捨離清單與斷捨離待辦狀態集中在 `AppViewModel`。
- 庫存資料以 `AppViewModel.items` 為主，透過 `Item.spaceId` 關聯空間。
- `Space` 僅保存空間顯示資訊；不另外保存物品陣列，避免和 `AppViewModel.items` 形成雙重資料來源。
- 共用日期格式與使用者輸入 trim 規則集中在 `Utilities/`。
- `DeclutterView` 可由 Dashboard 統計卡與清單頁進入。
- `DashboardView` 的購物模式入口會呼叫 `AppViewModel.startShoppingMode()`，切到清單頁並啟動柔性專注採買流程。

## 建議後續工作

1. 導入商品貼紙圖與空間線稿圖，取代 emoji / ASCII placeholder。
2. 補上資料持久化，避免每次啟動回到 `MockData` 初始狀態。
3. 將自然語言解析、相機辨識與提醒推播替換為真實服務。
4. 新增 test target，優先測 `AppViewModel` 與資料操作邏輯。
