# In Stock

`in_stock` 是一個 SwiftUI iOS app prototype，用於管理家中庫存、到期提醒、購物清單、空間分類與斷捨離項目。專案目前以 mock data 驅動畫面，重點放在 APP 資訊架構、主要流程與設計稿實作驗證。

## 功能概覽

- Mock 登入與註冊流程。
- 首頁 Dashboard：顯示購物清單、斷捨離、低庫存、即將過期等摘要。
- 提醒中心：低庫存、即將到期、斷捨離待辦等通知卡片。
- 空間管理：以廚房、客廳、臥室、浴室分類展示物品。
- 新增物品：包含自然語言輸入、相機辨識、確認表單與空間預選的 mock 流程。
- 清單：支援清單模式、購物模式、數量 stepper 與新增購物品項。
- 斷捨離：包含清單、詳情、設定儲存與新增項目。
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
├── blueprint/             # APP design mockups
├── in_stock.xcodeproj/    # Xcode project
├── BLUEPRINT_IMPLEMENTATION_REPORT.md
├── SOURCE_CODE_GUIDE.md
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
- 新增空間、購物品項、斷捨離項目與斷捨離設定已具備 mock 操作。
- 設計稿中的實物圖片與線稿資產尚未完整導入。
- 尚未建立 XCTest test target。

更多細節請參考：

- [SOURCE_CODE_GUIDE.md](SOURCE_CODE_GUIDE.md)：source code 導讀。
- [BLUEPRINT_IMPLEMENTATION_REPORT.md](BLUEPRINT_IMPLEMENTATION_REPORT.md)：設計稿對照、完成度與偏差報告。

## 設計稿

`blueprint/` 目錄包含 5 張 APP 設計稿：

- `1.png`：首頁 / 提醒系統。
- `2.png`：空間 / 物品展示。
- `3.png`：新增物品 / 自動辨識。
- `4.png`：清單 / 購物模式。
- `5.png`：斷捨離 / 設定成就。

## 開發注意事項

- App 入口為 `InStockApp`，會注入 `AuthViewModel` 與 `AppViewModel`。
- 主畫面由 `MainContainerView` 透過 `AppTab` 切換。
- 初始資料集中在 `MockData.shared`。
- 目前庫存、購物清單、斷捨離清單與斷捨離待辦狀態集中在 `AppViewModel`。
- 庫存資料以 `AppViewModel.items` 為主，透過 `Item.spaceId` 關聯空間。
- `Space` 僅保存空間顯示資訊；不另外保存物品陣列，避免和 `AppViewModel.items` 形成雙重資料來源。
- 共用日期格式與使用者輸入 trim 規則集中在 `Utilities/`。
- `DeclutterView` 可由 Dashboard 統計卡與清單頁進入。

## 建議後續工作

1. 導入商品貼紙圖與空間線稿圖，取代 emoji / ASCII placeholder。
2. 補上資料持久化，避免每次啟動回到 `MockData` 初始狀態。
3. 將自然語言解析、相機辨識與提醒推播替換為真實服務。
4. 新增 test target，優先測 `AppViewModel` 與資料操作邏輯。
