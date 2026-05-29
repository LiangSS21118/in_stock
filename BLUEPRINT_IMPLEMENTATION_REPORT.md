# Blueprint 實作完成度與偏差報告

本報告根據 `blueprint/` 內的 5 張 reference boards 對照目前 SwiftUI 實作，整理 app 當前完成度、實作偏差與建議修正順序。圖片檔名與索引請以 `blueprint/README.md` 為準。

## Blueprint 對照索引

| File | Scope |
| --- | --- |
| `blueprint/01-dashboard-reminders.png` | 首頁 Dashboard / 提醒系統 |
| `blueprint/02-spaces-items.png` | 空間 / 物品展示 |
| `blueprint/03-add-item-recognition.png` | 新增物品 / 自然語言輸入 / 相機辨識 / 確認表單 |
| `blueprint/04-lists-shopping-mode.png` | 清單模式 / 購物模式 |
| `blueprint/05-declutter-profile.png` | 斷捨離 / 設定 / Profile 成就 |

## 整體結論

目前專案完成度約 **80% - 85%**。主要流程與資訊架構已能完整串起：首頁、空間、清單、新增物品、個人頁、斷捨離相關畫面都有 SwiftUI 實作，且多數 mock 操作已可更新 shared state。近期新增了購物專注流程與購物完畢回補庫存，功能完整度提升，但目前仍偏「可操作 prototype + mock UI」，距離設計稿仍有明顯落差，尤其是：

- 設計稿大量使用實物圖片、線稿插圖、貼紙風商品卡；目前幾乎全部用 emoji / SF Symbols / ASCII art 代替。
- 斷捨離清單已可從 Dashboard 與清單頁進入，但仍不是獨立 tab。
- 新增 / 儲存相關 action 已補上 mock flow，但尚未持久化。
- 新增物品表單已改為 compact row layout，但視覺與素材仍未完全貼近設計稿。
- 清單 / 購物模式的版面有實作，但視覺密度、紙張感、卡片尺寸與商品建議列仍偏離。

## 01 首頁 / 提醒系統

Reference: `blueprint/01-dashboard-reminders.png`

設計稿重點：
- 首頁上方有「庫存模式」大卡與四個統計小卡。
- 快用完、即將過期用橫向商品貼紙卡呈現。
- 提醒中心包含推播提醒卡片。

目前實作：
- `DashboardView` 已有歡迎文字、統計卡、快用完、即將過期、提醒中心。
- 首頁已改為「購物模式」入口大卡，點擊後進入採買流程。卡片會根據 `isShoppingFocusActive` 動態顯示「繼續採買」或「購物模式」。
- 提醒中心和 `NotificationCard` 已有通知卡片。
- `AppViewModel.lowStockItems`、`expiringSoonItems` 已能從 mock item 過濾。
- 購物清單數字已改讀 `AppViewModel.shoppingItems` live state。

主要偏差：
- 視覺風格：商品卡目前用 emoji，不是設計稿的實物貼紙圖片。
- 提醒卡目前品牌列固定顯示 `In Stock`，與設計稿比例略有不同。

完成度：**約 85%**。流程已升級為動態採買入口，主要剩餘工作為視覺資產替換。

## 02 空間 / 物品展示

Reference: `blueprint/02-spaces-items.png`

設計稿重點：
- 空間首頁有大型房屋線稿。
- 空間卡使用線稿插圖。
- 物品以去背貼紙卡呈現。

目前實作：
- `SpaceView` 已有空間列表、房屋 ASCII header、新增空間卡。支援搜尋功能，搜尋時顯示物品 grid。
- `SpaceDetailView` 已有單一空間頁、該空間物品 grid、新增物品卡。
- 空間與物品關聯已收斂為 `AppViewModel.items` + `Item.spaceId`。

主要偏差：
- 設計稿是精緻線稿插圖；目前是 ASCII art，風格方向接近但完成度不足。
- 商品卡仍是 emoji，不是實物圖。

完成度：**約 75%**。資訊架構與搜尋流程已完善，但視覺資產仍不足。

## 03 新增物品 / 自動辨識

Reference: `blueprint/03-add-item-recognition.png`

設計稿重點：
- 自然語言輸入與相機辨識。
- 最後新增表單是緊湊的 iOS 表單樣式。

目前實作：
- `AddItemEntryView` 有自然語言與相機兩個入口。
- `AddItemConfirmView` 有 compact row 確認表單，包含數量 stepper、位置、耗品 toggle 與提醒門檻。

主要偏差：
- 相機與 NLP 仍是 mock 實現。
- 新增表單已有單列日期與數量 stepper，但照片仍是 emoji placeholder。

完成度：**約 70%**。表單規格已收斂，但底層辨識技術與實物照片仍為 mock。

## 04 清單 / 購物模式

Reference: `blueprint/04-lists-shopping-mode.png`

設計稿重點：
- 清單模式是微調過的紙張感 checklist。
- 購物模式顯示 checkbox、品名、數量 stepper、新增品項。

目前實作：
- `ListView` 提供清單與購物兩種模式，並支援搜尋功能快速加入庫存物品。
- 採買專注狀態：隱藏非必要 UI，頂部顯示專注狀態，保留導覽彈性。
- `ShoppingModeView` 提供 `QuantityStepper`、新增品項列、低庫存快速加入。
- 「購物完畢」回補流程：`RestockConfirmationView` 支援已匹配庫存自動回補，未匹配項目可手動分配空間。
- 清單狀態已完全收斂到 `AppViewModel`。

主要偏差：
- 視覺：清單模式紙張卡仍非單一大表格式，與設計稿仍有差距。
- 建議列：設計稿建議卡使用實物圖片；目前仍以文字建議為主。

完成度：**約 95%**。功能深度已顯著超過原稿，形成了完整的採買回補閉環。

## 05 斷捨離 / 設定成就

Reference: `blueprint/05-declutter-profile.png`

設計稿重點：
- 斷捨離清單管理。
- Profile / 設定頁有個人資料、設定、成就卡。

目前實作：
- `DeclutterView`、`DeclutterDetailView`、`DeclutterSettingsView` 功能完整。
- `ProfileView` 提供帳戶設定入口。
- `AchievementView` 已實作：展示一個展示 `doneDeclutterItems`（已成功斷捨離項目）的貼紙卡 grid，並配有 ASCII 獎盃。
- `StatusBadge` 可呈現捐贈、二手出售、丟棄狀態。

主要偏差：
- 斷捨離清單目前使用 emoji，不是照片。
- 成就頁面目前優先展示具體的已完成項目（貼紙卡），而非純統計數字，這比設計稿更具儀式感，但也屬視覺偏差。

完成度：**約 80%**。主要流程已補上，剩餘工作為視覺細節與實物照片替換。

## 視覺完成度總評

目前 app 的設計語言方向大致吻合：黑白灰、圓角卡片、底部 tab、簡潔資訊卡。但設計稿的關鍵視覺特色尚未真正落地：
- 實物貼紙圖片：幾乎未完成。
- 空間線稿插圖：以 ASCII 暫代。
- 商品去背卡片：以 emoji 暫代。
- 表單 compact layout：部分已收斂，但仍有優化空間。
- 紙張感 checklist：有嘗試，但還不夠像設計稿。

視覺完成度：**約 50% - 55%**。

## 功能完成度總評

已完成或部分完成：
- 登入 / 註冊 mock。
- 首頁統計、提醒與動態採買入口。
- 空間列表、搜尋與空間詳情。
- 新增物品 mock 流程與回補流程。
- 清單模式 / 購物模式切換與專注狀態。
- Profile 與成就貼紙展示。
- 斷捨離主流程與設定。

未完成或明顯缺口：
- 真實資料持久化。
- 商品 / 空間圖片資產。
- 真實辨識服務。

功能完成度：**約 85% - 90%**。

## 建議優先修正順序

1. 用 image assets 取代 emoji / ASCII。
2. 補上資料持久化。
3. 將 mock 辨識流程替換為真實服務。
4. 進一步精進視覺細節（紙張感、陰影、比例）。
5. 新增 XCTest target。
