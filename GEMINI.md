# Project Overview: in_stock

`in_stock` is a SwiftUI iOS app prototype for managing home inventory, expiry reminders, shopping lists, space-based item organization, and decluttering items. The project currently uses mock data and focuses on validating the app information architecture, primary flows, and blueprint-driven UI direction.

## Main Technologies

- **Language:** Swift
- **UI Framework:** SwiftUI
- **Build System:** Xcode project in `in_stock.xcodeproj`
- **Data:** In-memory state and mock data from `Data/MockData.swift`

There is currently no backend, database, network layer, real persistence, push notification implementation, camera recognition, or real natural-language parsing.

## Project Structure

- `in_stock/`: Main application source code.
  - `in_stockApp.swift`: App entry point. Creates and injects `AuthViewModel` and `AppViewModel`.
  - `ContentView.swift`: Preview-friendly root wrapper.
  - `Views/`: Feature views grouped by area, including `Auth`, `Dashboard`, `Lists`, `Profile`, `Root`, and `Spaces`.
  - `Components/`: Reusable SwiftUI controls, cards, tab bar, badges, and item UI.
  - `Models/`: Domain models and enums such as `Item`, `Space`, `AppTab`, and `DeclutterItem`.
  - `ViewModels/`: Observable state and mock operation logic.
  - `Data/MockData.swift`: Sample users, spaces, inventory items, shopping list items, declutter items, notifications, and achievements.
  - `Theme/AppTheme.swift`: Shared colors, fonts, spacing, and view styles.
  - `Utilities/`: Shared helpers for app date formatting and user input trimming.
  - `Assets.xcassets/`: App icons, accent colors, and image assets.
- `blueprint/`: Design reference boards and `README.md` image index.
- `SOURCE_CODE_GUIDE.md`: Architecture, data flow, screen, and technical debt notes.
- `BLUEPRINT_IMPLEMENTATION_REPORT.md`: Blueprint comparison, completion estimates, gaps, and suggested priorities.
- `README.md`: User-facing project summary and setup instructions.

## App Flow

`InStockApp` injects `AuthViewModel` and `AppViewModel` into `RootView`.

`RootView` decides between:

- `LoginView` when `AuthViewModel.isLoggedIn` is false.
- `MainContainerView` when the user is logged in.

`MainContainerView` uses `AppViewModel.selectedTab` and `AppTab` to switch between:

- Dashboard
- Spaces
- Add Item
- Lists
- Profile (Settings)

`DeclutterView` and related decluttering screens can be accessed from the Dashboard (Declutter stat card) or the Lists tab (Checklist mode).

## Current Implementation Notes

- `MockData.shared` is a data factory. Its collections are computed properties and should not be treated as persistent storage.
- App-wide inventory state lives in `AppViewModel.items`.
- Space-to-item ownership is represented only by `Item.spaceId`; `Space` stores display metadata and placeholder ASCII art.
- Dashboard, checklist mode, and shopping mode all read shared list state from `AppViewModel`.
- Shopping-mode row actions and quantity adjustments go through `AppViewModel` methods; quantity adjustment is disabled for checked items.
- Shopping mode includes a "Soft Focus" state: hiding non-essential UI (segmented control, search) while keeping navigation accessible.
- Search functionality is enabled in `ListView` and `SpaceView`, allowing real-time filtering of items and shopping list entries.
- Shopping completed flow uses `ShoppingRestockEntry` to match items; matched items increment inventory quantity and reset remaining percentage to 100%. Unmatched items can be added as new inventory with space/location selection.
- `DeclutterView` displays items currently being decluttered. When a decluttering task is checked off in the `ChecklistModeView`, the item is moved to `doneDeclutterItems` and appears in the `AchievementView` grid.
- `AchievementView` displays a grid of `doneDeclutterItems` as sticker cards, celebrating successfully decluttered items.
- Dashboard shopping card is dynamic, showing "Continue Shopping" when focus is active.
- Add item flows are mock implementations: natural language parsing and camera recognition use hardcoded behavior with `nextFutureDate` logic to avoid expired dates.
- Adding spaces, shopping items, declutter items, and declutter settings all have mock state updates using `String.trimmedForUserInput`.
- Date strings use `AppDateFormatter` for consistency; form empty checks use `String.trimmedForUserInput`.
- The visual implementation still relies heavily on emoji, SF Symbols, and ASCII placeholders where blueprint images show product stickers or room line art.

## Building and Running

Open the project in Xcode:

```bash
open in_stock.xcodeproj
```

Build from the command line:

```bash
xcodebuild -project in_stock.xcodeproj -scheme in_stock -destination 'platform=iOS Simulator,name=iPhone 16' build
```

If `iPhone 16` is unavailable, use an installed simulator name.

Run tests once a test target exists:

```bash
xcodebuild test -project in_stock.xcodeproj -scheme in_stock -destination 'platform=iOS Simulator,name=iPhone 16'
```

No XCTest target is currently committed.

## Development Conventions

- Follow standard Swift and SwiftUI conventions with 4-space indentation.
- Use `PascalCase` for types and `camelCase` for properties, methods, and local variables.
- Keep SwiftUI views feature-scoped and small.
- Move shared UI into `Components/`.
- Move shared colors, fonts, spacing, and card styling into `Theme/AppTheme.swift`.
- Prefer `struct` views.
- Use `@StateObject` for view-owned observable models.
- Use `@EnvironmentObject` for app-wide state injected at the root.
- Keep sample-only data in `Data/MockData.swift`.
- Do not introduce secrets, signing credentials, provisioning profiles, or production configuration.

## UI Direction

Follow the blueprint direction documented in `BLUEPRINT_IMPLEMENTATION_REPORT.md`: compact inventory cards, restrained black/white/gray styling, bottom tab navigation, sticker-like item cards, space illustrations, and paper-like checklist screens.

Blueprint image filenames are semantic and ordered:

- `blueprint/01-dashboard-reminders.png`
- `blueprint/02-spaces-items.png`
- `blueprint/03-add-item-recognition.png`
- `blueprint/04-lists-shopping-mode.png`
- `blueprint/05-declutter-profile.png`

When adding or replacing reference boards, update `blueprint/README.md` and `BLUEPRINT_IMPLEMENTATION_REPORT.md` together.

When improving blueprint-facing screens, prioritize:

1. Replacing emoji and ASCII placeholders with real assets in `Assets.xcassets`.
2. Adding persistence so mock state survives app restart.
3. Replacing mock natural-language parsing, camera recognition, and reminders with real services.
4. Adding an XCTest target for `AppViewModel` and model behavior.
5. Continuing visual polish on checklist paper styling, sticker item cards, reminder cards, and declutter rows.
