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

目前專案完成度約 **75% - 80%**。主要流程與資訊架構已能完整串起：首頁、空間、清單、新增物品、個人頁、斷捨離相關畫面都有 SwiftUI 實作，且多數 mock 操作已可更新 shared state。近期新增了購物專注流程與購物完畢回補庫存，功能完整度提升，但目前仍偏「可操作 prototype + mock UI」，距離設計稿仍有明顯落差，尤其是：

- 設計稿大量使用實物圖片、線稿插圖、貼紙風商品卡；目前幾乎全部用 emoji / SF Symbols / ASCII art 代替。
- 斷捨離清單已可從 Dashboard 與清單頁進入，但仍不是獨立 tab。
- 新增 / 儲存相關 action 已補上 mock flow，但尚未持久化。
- 新增物品表單已改為 compact row layout，但視覺與素材仍未完全貼近設計稿。
- 清單 / 購物模式的版面有實作，但視覺密度、紙張感、卡片尺寸與商品建議列仍偏離。
- Dashboard 首頁的核心資訊順序與設計稿不同。

## 01 首頁 / 提醒系統

Reference: `blueprint/01-dashboard-reminders.png`

設計稿重點：

- 首頁上方有「庫存模式」大卡與四個統計小卡。
- 快用完、即將過期用橫向商品貼紙卡呈現。
- 提醒中心包含推播提醒卡片。
- 右側說明了低庫存提醒、即將到期提醒、購物模式切換、推播通知提醒。

目前實作：

- `DashboardView` 已有歡迎文字、統計卡、快用完、即將過期、提醒中心。
- 首頁已改為「購物模式」入口大卡，點擊後直接進入清單頁購物專注狀態。
- `ReminderCenterView` 和 `NotificationCard` 已有通知卡片。
- `AppViewModel.lowStockItems`、`expiringSoonItems` 已能從 mock item 過濾。
- 購物清單數字已改讀 `AppViewModel.shoppingItems` live state。

主要偏差：

- 原設計稿寫「庫存模式」命名；目前是有意識改成「購物模式」入口，屬產品策略調整而非純視覺偏差。
- 底部 tab 的第二個 icon 目前是 grid，設計稿是圖片 / 空間 icon 風格，語意略不同。
- 商品卡目前用 emoji，不是設計稿的實物貼紙圖片。
- 設計稿首頁商品卡尺寸較小、貼紙陰影明顯；目前 `StickerItemCard` 比較像一般白卡。
- 提醒卡目前品牌列固定顯示 `In Stock`，但 icon、排版、卡片比例和設計稿不完全一致。

完成度：**約 80%**。首頁流程已升級為購物入口，但商品素材與提醒卡視覺仍需補強。

## 02 空間 / 物品展示

Reference: `blueprint/02-spaces-items.png`

設計稿重點：

- 空間首頁有大型房屋線稿。
- 空間卡使用線稿插圖，例如廚房、客廳、臥室、浴室。
- 空間詳情頁是單一空間，不做上方切換。
- 物品以去背貼紙卡呈現，含名稱、剩餘量、日期。
- 新增物品是一張虛線卡。

目前實作：

- `SpaceView` 已有空間列表、房屋 ASCII header、新增空間卡。
- `SpaceDetailView` 已有單一空間頁、該空間物品 grid、新增物品卡。
- `itemsForSpace(space.id)` 已能正確按空間過濾。
- 空間與物品關聯已收斂為 `AppViewModel.items` + `Item.spaceId`，`Space` 不再保存第二份物品陣列。
- 新增空間分類會開啟 sheet 建立 mock 空間。
- 從空間詳情新增物品時，新增流程會預選該空間。

主要偏差：

- 設計稿是精緻線稿插圖；目前是 ASCII art，風格方向接近但完成度不足。
- `Space.illustrationName` 欄位存在，但 UI 沒使用，實際顯示 `asciiArtText`。
- 設計稿空間卡是線稿圖片；目前空間卡是純文字 ASCII。
- 商品卡仍是 emoji，不是實物圖。
- 空間詳情頁設計稿有返回箭頭與大幅廚房線稿；目前是 NavigationStack 預設返回 + ASCII 卡片。

完成度：**約 70%**。資訊架構與新增流程已可操作，但視覺資產仍不足。

## 03 新增物品 / 自動辨識

Reference: `blueprint/03-add-item-recognition.png`

設計稿重點：

- 自然語言輸入是一個 compact 卡片，解析後自動填入品項、數量、到期日。
- 拍照自動辨識畫面是真實相機取景，底部浮出辨識結果。
- 最後新增表單是緊湊的 iOS 表單樣式，包含：
  - 商品照片。
  - 物品名稱。
  - 數量 stepper。
  - 到期日。
  - 所在空間 / 位置。
  - 是否為耗品 toggle。
  - 提醒門檻 dropdown。
  - 新增按鈕。

目前實作：

- `AddItemEntryView` 有自然語言與相機兩個入口。
- `NaturalLanguageInputView` 有文字輸入、mock 解析結果、下一步。
- `CameraRecognitionView` 有 mock camera viewfinder。
- `AddItemConfirmView` 有 compact row 確認表單，包含數量 stepper、位置、耗品 toggle 與提醒門檻，並能新增到 `AppViewModel.items`。

主要偏差：

- 自然語言輸入目前是整頁 TextEditor，不是設計稿 compact 卡片。
- 相機畫面是黑底 + emoji placeholder，不是真實相機或設計稿中的照片取景。
- 辨識結果卡存在，但視覺與設計稿差距大。
- 新增表單已有單列日期與數量 stepper，但商品照片仍是 emoji placeholder。
- 所在空間與位置已拆開，但尚未支援更完整的位置管理。
- mock 日期已避免固定 2024/05/02，但解析仍不是真實 NLP。

完成度：**約 70%**。流程與表單規格更接近設計稿，但相機、照片與 NLP 仍是 mock。

## 04 清單 / 購物模式

Reference: `blueprint/04-lists-shopping-mode.png`

設計稿重點：

- 清單模式是微調過的紙張感 checklist。
- 購物模式是同一個清單畫面切換後的狀態。
- 購物模式顯示 checkbox、品名、數量 stepper、新增品項。
- 下方有建議購入、建議斷捨離橫向卡片。
- 設計稿特別強調沿用原清單版面，只微調並補上購物模式切換後畫面。

目前實作：

- 一般狀態下 `ListView` 仍有 segmented control。
- 進入購物模式時啟動柔性專注：隱藏 segmented control 與搜尋，保留底部 tab，但暫離會提示確認。
- `ChecklistModeView` 有購物清單、斷捨離待辦、建議購入、建議斷捨離。
- `ShoppingModeView` 聚焦為購物清單與斷捨離清單，提供 `QuantityStepper`、新增品項列、低庫存快速加入。
- 低庫存快速加入會帶入 `sourceItemId`，同來源或同名項目以數量遞增方式合併。
- `RestockConfirmationView` 支援「購物完畢」回補流程：已匹配項目回補原庫存，未匹配項目可補空間/位置或略過。
- 清單狀態已收斂到 `AppViewModel`，Dashboard 與清單頁讀同一份資料。

主要偏差：

- 設計稿假設購物模式只做輕切換；目前已升級為完整採買流程（focus + 回補），屬產品策略加值。
- 清單模式紙張卡仍非單一大表格式，與設計稿仍有差距。
- 設計稿建議卡使用實物圖片；目前仍以 emoji 為主。
- checklist 日期、progress 有做，但部分內容是硬編碼。

完成度：**約 85%**。功能流程已超過原稿深度，但視覺細節和素材仍需補強。

## 05 斷捨離 / 設定成就

Reference: `blueprint/05-declutter-profile.png`

設計稿重點：

- 斷捨離清單在主 app 中可進入。
- 每列有實物照片、名稱、位置、日期、狀態 badge。
- 斷捨離設定是表單卡，包含原因、上次使用時間、提醒週期、給未來自己的話。
- Profile / 設定頁有個人資料、設定、成就卡、下一個里程碑。

目前實作：

- `DeclutterView`、`DeclutterDetailView`、`DeclutterSettingsView` 都已存在。
- `DeclutterView` 可從 Dashboard 與清單頁進入。
- 斷捨離清單可新增 mock 項目，設定頁會寫回 `AppViewModel.declutterItems`。
- `ProfileView` 與 `AchievementView` 已實作成就與里程碑。
- `StatusBadge` 已可呈現捐贈、二手出售、丟棄狀態。

主要偏差：

- 斷捨離清單目前使用 emoji，不是照片。
- 設計稿 list row 比目前更接近圖文資料列；目前 row 比較像一般卡片。
- Profile 成就區已改為三欄卡，但圖示與細節仍未完全符合設計稿。
- Profile 設定列有登出，但設計稿只顯示個人資料與設定；這是功能上合理擴充，但非設計稿一致。

完成度：**約 75%**。主流程與資料更新已補上，主要剩照片素材與 row 視覺細節。

## 視覺完成度總評

目前 app 的設計語言方向大致吻合：黑白灰、圓角卡片、底部 tab、簡潔資訊卡。但設計稿的關鍵視覺特色尚未真正落地：

- 實物貼紙圖片：幾乎未完成。
- 空間線稿插圖：以 ASCII 暫代。
- 商品去背卡片：以 emoji 暫代。
- 表單 compact layout：新增物品表單已收斂，部分設定表單仍偏 SwiftUI 預設。
- 紙張感 checklist：有嘗試，但還不夠像設計稿。
- 圖示與品牌感：目前主要使用 SF Symbols，設計稿中的 app icon / bag icon 風格尚未統一。

視覺完成度：**約 45% - 55%**。

## 功能完成度總評

已完成或部分完成：

- 登入 / 註冊 mock。
- 首頁統計與提醒。
- 空間列表與空間詳情。
- 新增物品 mock 流程。
- 清單模式 / 購物模式切換。
- Profile 與成就。
- 斷捨離主流程、設定儲存與新增項目。
- 新增空間與新增購物清單品項。
- 購物清單與 Dashboard 同步。
- 空間和庫存關聯已收斂到單一資料來源，並集中日期格式與輸入 trim helper。

未完成或明顯缺口：

- 真實資料持久化。
- 商品 / 空間圖片資產。
- 相機辨識與自然語言解析的真實功能。
- 提醒 / 推播真實機制。

功能完成度：**約 80% - 85%**。

## 建議優先修正順序

1. 用 image assets 取代 emoji / ASCII，至少先補商品貼紙圖與空間線稿圖。
2. 補上資料持久化，讓新增空間、庫存、購物清單與斷捨離項目能跨啟動保存。
3. 將相機辨識、自然語言解析與提醒推播替換為真實服務。
4. 進一步調整清單紙張感、商品卡尺寸、提醒卡比例與斷捨離 row，使視覺更接近設計稿。
5. 新增 XCTest target，優先測 `AppViewModel` 的資料操作與新增流程。
