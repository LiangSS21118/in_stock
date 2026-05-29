# Blueprint 實作完成度與偏差報告

本報告根據 `blueprint/1.png` 到 `blueprint/5.png` 對照目前 SwiftUI 實作，整理 APP 當前完成度、實作偏差與建議修正順序。

## 整體結論

目前專案完成度約 **55% - 65%**。主要流程與資訊架構大致都有搭起來：首頁、空間、清單、新增物品、個人頁、斷捨離相關畫面都已有 SwiftUI 實作。但目前更像是「功能骨架 + mock UI」，距離設計稿仍有明顯落差，尤其是：

- 設計稿大量使用實物圖片、線稿插圖、貼紙風商品卡；目前幾乎全部用 emoji / SF Symbols / ASCII art 代替。
- 斷捨離清單畫面已寫好，但沒有接入主 tab。
- 多個按鈕是空 action。
- 新增物品表單與設計稿差異較大。
- 清單 / 購物模式的版面有實作，但視覺密度、紙張感、卡片尺寸與商品建議列仍偏離。
- Dashboard 首頁的核心資訊順序與設計稿不同。

## 01 首頁 / 提醒系統

設計稿重點：

- 首頁上方有「庫存模式」大卡與四個統計小卡。
- 快用完、即將過期用橫向商品貼紙卡呈現。
- 提醒中心包含推播提醒卡片。
- 右側說明了低庫存提醒、即將到期提醒、購物模式切換、推播通知提醒。

目前實作：

- `DashboardView` 已有歡迎文字、統計卡、快用完、即將過期、提醒中心。
- `ReminderCenterView` 和 `NotificationCard` 已有通知卡片。
- `AppViewModel.lowStockItems`、`expiringSoonItems` 已能從 mock item 過濾。

主要偏差：

- 缺少設計稿中的「庫存模式」大卡。現在 Dashboard 只有四個同尺寸 `StatCard`。
- 底部 tab 的第二個 icon 目前是 grid，設計稿是圖片 / 空間 icon 風格，語意略不同。
- 商品卡目前用 emoji，不是設計稿的實物貼紙圖片。
- 設計稿首頁商品卡尺寸較小、貼紙陰影明顯；目前 `StickerItemCard` 比較像一般白卡。
- 提醒卡目前品牌列固定顯示 `In Stock`，但 icon、排版、卡片比例和設計稿不完全一致。
- Dashboard 的購物清單數量讀 `MockData.shared.shoppingItems.count`，不是實際清單狀態。

完成度：**約 65%**。資訊都有，但視覺和首頁核心卡片結構還沒貼近設計稿。

## 02 空間 / 物品展示

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

主要偏差：

- 設計稿是精緻線稿插圖；目前是 ASCII art，風格方向接近但完成度不足。
- `Space.illustrationName` 欄位存在，但 UI 沒使用，實際顯示 `asciiArtText`。
- 設計稿空間卡是線稿圖片；目前空間卡是純文字 ASCII。
- 商品卡仍是 emoji，不是實物圖。
- 空間詳情頁設計稿有返回箭頭與大幅廚房線稿；目前是 NavigationStack 預設返回 + ASCII 卡片。
- 新增空間分類按鈕是空 action。
- 空間詳情的「新增物品」只切到新增 tab，沒有帶入目前空間。

完成度：**約 60%**。資訊架構接近，但視覺資產和新增流程整合不足。

## 03 新增物品 / 自動辨識

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
- `AddItemConfirmView` 有確認表單並能新增到 `AppViewModel.items`。

主要偏差：

- 自然語言輸入目前是整頁 TextEditor，不是設計稿 compact 卡片。
- 相機畫面是黑底 + emoji placeholder，不是真實相機或設計稿中的照片取景。
- 辨識結果卡存在，但視覺與設計稿差距大。
- 新增表單目前使用 `DatePicker(.graphical)`，佔非常大空間；設計稿是單列日期欄位。
- 數量目前是 `TextField + unit TextField`，不是設計稿的 stepper。
- `reminderThreshold` 存在於 `AddItemViewModel`，但確認表單沒有實作提醒門檻選擇。
- 所在空間只有空間 picker，沒有「廚房 / 冰箱」這種空間 + 位置結構。
- 新增後沒有 reset 表單。
- mock 日期固定 2024/05/02，現在已過期。

完成度：**約 55%**。流程有，但互動細節與設計稿表單規格差距明顯。

## 04 清單 / 購物模式

設計稿重點：

- 清單模式是微調過的紙張感 checklist。
- 購物模式是同一個清單畫面切換後的狀態。
- 購物模式顯示 checkbox、品名、數量 stepper、新增品項。
- 下方有建議購入、建議斷捨離橫向卡片。
- 設計稿特別強調沿用原清單版面，只微調並補上購物模式切換後畫面。

目前實作：

- `ListView` 有 segmented control。
- `ChecklistModeView` 有購物清單、斷捨離待辦、建議購入、建議斷捨離。
- `ShoppingModeView` 有購物清單、checkbox、plus/minus quantity、新增品項列、建議購入。
- `ListViewModel` 有 toggle 與 quantity update。

主要偏差：

- 設計稿清單模式的紙張卡是一大張表格式；目前是兩張 `PaperChecklistCard` 分開呈現。
- 購物模式設計稿比較像列表，現在每一列是獨立白卡，視覺偏重。
- `QuantityStepper` 元件存在但未使用，購物模式手寫 plus/minus。
- 「新增品項」按鈕是空 action。
- 設計稿建議卡使用實物圖片；目前是 emoji。
- checklist 日期、progress 有做，但部分內容是硬編碼。
- 清單資料存在 `ListViewModel`，未和 Dashboard / AppViewModel 同步。

完成度：**約 70%**。功能與模式切換最接近設計稿，但視覺細節和新增品項未完成。

## 05 斷捨離 / 設定成就

設計稿重點：

- 斷捨離清單在主 app 中可進入。
- 每列有實物照片、名稱、位置、日期、狀態 badge。
- 斷捨離設定是表單卡，包含原因、上次使用時間、提醒週期、給未來自己的話。
- Profile / 設定頁有個人資料、設定、成就卡、下一個里程碑。

目前實作：

- `DeclutterView`、`DeclutterDetailView`、`DeclutterSettingsView` 都已存在。
- `ProfileView` 與 `AchievementView` 已實作成就與里程碑。
- `StatusBadge` 已可呈現捐贈、二手出售、丟棄狀態。

主要偏差：

- 最大問題：`DeclutterView` 沒有接入 `MainContainerView`，主流程進不到。
- 斷捨離清單目前使用 emoji，不是照片。
- 設計稿 list row 比目前更接近圖文資料列；目前 row 比較像一般卡片。
- `DeclutterSettingsView` 是 standalone local state，沒有把設定寫回 `DeclutterItem` 或 `AppViewModel`。
- 「新增斷捨離項目」是空 action。
- Profile 視覺接近，但成就設計稿是三欄卡；目前用 LazyVGrid 兩欄，和設計稿偏差明顯。
- Profile 設定列有登出，但設計稿只顯示個人資料與設定；這是功能上合理擴充，但非設計稿一致。

完成度：**約 50%**。畫面素材有做，但主流程接入與資料更新還沒完成。

## 視覺完成度總評

目前 app 的設計語言方向大致吻合：黑白灰、圓角卡片、底部 tab、簡潔資訊卡。但設計稿的關鍵視覺特色尚未真正落地：

- 實物貼紙圖片：幾乎未完成。
- 空間線稿插圖：以 ASCII 暫代。
- 商品去背卡片：以 emoji 暫代。
- 表單 compact layout：部分畫面使用 SwiftUI 預設大元件，偏離設計稿。
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
- 斷捨離相關畫面檔案。

未完成或明顯缺口：

- 真實資料持久化。
- 商品 / 空間圖片資產。
- 新增空間。
- 新增購物清單品項。
- 新增斷捨離項目。
- 斷捨離設定儲存。
- 斷捨離主入口。
- 購物清單與 Dashboard 同步。
- 相機辨識與自然語言解析的真實功能。
- 提醒 / 推播真實機制。

功能完成度：**約 60% - 65%**。

## 建議優先修正順序

1. 接上 `DeclutterView` 主流程，或明確決定它要從清單 / Profile / Dashboard 哪裡進入。
2. 將購物清單狀態搬到 `AppViewModel` 或共享 store，避免 Dashboard 和 List 不同步。
3. 補齊所有空 action：新增空間、新增品項、新增斷捨離項目、儲存設定。
4. 調整新增物品確認表單，改成設計稿的 compact row layout，補上提醒門檻。
5. 用 image assets 取代 emoji / ASCII，至少先補商品貼紙圖與空間線稿圖。
6. 修正 mock 日期，避免新增或通知顯示過期的 2024 日期。
7. Profile 成就區改成設計稿三欄卡片，提升一致性。
8. 新增後 reset `AddItemViewModel`，並支援從空間詳情新增時預選該空間。
