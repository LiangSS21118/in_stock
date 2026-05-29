# Repository Guidelines

## Project Structure & Module Organization
This repository contains a SwiftUI Xcode project for the `in_stock` app.

- `in_stock/` contains application source code.
- `in_stock/Views/` is organized by feature area, such as `Auth`, `Dashboard`, `Lists`, `Profile`, and `Spaces`.
- `in_stock/Components/` holds reusable SwiftUI controls and cards.
- `in_stock/Models/`, `ViewModels/`, `Data/`, and `Theme/` contain domain types, observable state, mock data, and shared styling.
- `in_stock/Assets.xcassets/` stores app icons, accent colors, and image assets.
- `blueprint/` contains design reference images.
- `in_stock.xcodeproj/` is the Xcode project configuration.

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

## Coding Style & Naming Conventions
Follow standard Swift and SwiftUI conventions with 4-space indentation. Use `PascalCase` for types (`DashboardView`, `AuthViewModel`) and `camelCase` for properties, methods, and local variables. Keep SwiftUI views small and feature-scoped; move shared UI into `Components/` and shared colors, fonts, or spacing into `Theme/AppTheme.swift`. Prefer `struct` views, `@StateObject` for owned observable models, and `@EnvironmentObject` for app-wide state already provided at the root.

## Testing Guidelines
No test target is currently committed. When adding tests, create an XCTest target such as `in_stockTests/`, mirror the source feature names, and name files like `ListViewModelTests.swift`. Focus unit tests on view models and model behavior; use UI tests only for core flows such as authentication, item entry, and list management.

## Commit & Pull Request Guidelines
The existing history uses short, direct commit messages such as `Add blueprint`. Continue with concise imperative messages, for example `Add list filtering` or `Fix quantity stepper bounds`.

Pull requests should include a clear summary, testing notes, linked issues when applicable, and screenshots or screen recordings for visible UI changes. Mention any simulator/device used for validation and note when tests are not available.

## Security & Configuration Tips
Do not commit personal signing credentials, provisioning profiles, or secrets. Keep sample-only data in `Data/MockData.swift` and avoid mixing mock data with production configuration.
