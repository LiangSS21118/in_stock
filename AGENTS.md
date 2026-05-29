# Repository Guidelines

## Project Structure & Module Organization
This repository contains a SwiftUI Xcode project for the `in_stock` app, an iOS prototype for home inventory, expiry reminders, shopping lists, space-based item organization, and decluttering workflows. The app is currently mock-data driven and focused on information architecture, primary flows, and blueprint validation.

- `in_stock/` contains application source code.
- `in_stock/Views/` is organized by feature area, such as `Auth`, `Dashboard`, `Lists`, `Profile`, and `Spaces`.
- `in_stock/Components/` holds reusable SwiftUI controls and cards.
- `in_stock/Models/`, `ViewModels/`, `Data/`, and `Theme/` contain domain types, observable state, mock data, and shared styling.
- `in_stock/Assets.xcassets/` stores app icons, accent colors, and image assets.
- `blueprint/` contains semantic design reference boards and `blueprint/README.md` maps each board to app areas.
- `in_stock.xcodeproj/` is the Xcode project configuration.
- `SOURCE_CODE_GUIDE.md` documents the app architecture, data flow, and known technical debt.
- `BLUEPRINT_IMPLEMENTATION_REPORT.md` compares the SwiftUI implementation against the design blueprints.

## Build, Test, and Development Commands
Open and run the app from Xcode:

```bash
open in_stock.xcodeproj
```

Build from the command line:

```bash
xcodebuild -project in_stock.xcodeproj -scheme in_stock -destination 'platform=iOS Simulator,name=iPhone 16' build
```

Run tests once a test target exists:

```bash
xcodebuild test -project in_stock.xcodeproj -scheme in_stock -destination 'platform=iOS Simulator,name=iPhone 16'
```

Use an installed simulator name if `iPhone 16` is unavailable.

## Architecture Notes
`InStockApp` is the app entry point and injects `AuthViewModel` and `AppViewModel` through the environment. `RootView` switches between `LoginView` and `MainContainerView` based on `AuthViewModel.isLoggedIn`. `MainContainerView` uses `AppTab` to show Dashboard, Spaces, Add Item, Lists, and Profile.

Initial sample data lives in `Data/MockData.swift`. Treat it as a data factory, not persistence. App-wide inventory state currently lives in `AppViewModel.items`; `Space.items` is not the main source of truth. Several flows remain mock-only or placeholders, including real authentication, natural-language parsing, camera recognition, persistence, and push reminders.

## Coding Style & Naming Conventions
Follow standard Swift and SwiftUI conventions with 4-space indentation. Use `PascalCase` for types (`DashboardView`, `AuthViewModel`) and `camelCase` for properties, methods, and local variables. Keep SwiftUI views small and feature-scoped; move shared UI into `Components/` and shared colors, fonts, or spacing into `Theme/AppTheme.swift`. Prefer `struct` views, `@StateObject` for owned observable models, and `@EnvironmentObject` for app-wide state already provided at the root. Preserve the existing SwiftUI design direction: compact cards, restrained black/white/gray styling, feature-scoped views, and shared visual primitives from `Theme/AppTheme.swift` and `Components/`. When implementing blueprint-facing UI, prefer replacing emoji or ASCII placeholders with assets in `Assets.xcassets` instead of introducing unrelated visual styles.

## Testing Guidelines
No test target is currently committed. When adding tests, create an XCTest target such as `in_stockTests/`, mirror the source feature names, and name files like `ListViewModelTests.swift`. Focus unit tests on view models and model behavior; use UI tests only for core flows such as authentication, item entry, and list management. If tests cannot be run because the target does not exist, note that explicitly in the validation summary.

## Commit & Pull Request Guidelines
The existing history uses short, direct commit messages such as `Add blueprint`. Continue with concise imperative messages, for example `Add list filtering` or `Fix quantity stepper bounds`.

Pull requests should include a clear summary, testing notes, linked issues when applicable, and screenshots or screen recordings for visible UI changes. Mention any simulator/device used for validation and note when tests are not available.

## Security & Configuration Tips
Do not commit personal signing credentials, provisioning profiles, or secrets. Keep sample-only data in `Data/MockData.swift` and avoid mixing mock data with production configuration.
