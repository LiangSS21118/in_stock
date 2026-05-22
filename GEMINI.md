# Project Overview: in_stock

`in_stock` is a SwiftUI application for iOS/macOS. It is a standard Xcode-managed project using the modern SwiftUI app lifecycle.

## Main Technologies
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Build System:** Xcode (build settings defined in `in_stock.xcodeproj`)

## Project Structure
- `in_stock/`: Contains the main source code.
    - `in_stockApp.swift`: The entry point of the application.
    - `ContentView.swift`: The main initial view of the application.
    - `Assets.xcassets/`: Asset catalogs for images, colors, and icons.
- `in_stock.xcodeproj/`: Xcode project configuration.

## Building and Running

### Using Xcode
1. Open `in_stock.xcodeproj` in Xcode.
2. Select the desired scheme and destination (e.g., iPhone Simulator or My Mac).
3. Press `Cmd + R` to build and run.

### Using Command Line (xcodebuild)
To build the project from the terminal:
```bash
xcodebuild -project in_stock.xcodeproj -scheme in_stock -sdk iphonesimulator build
```
*Note: You may need to specify the correct destination for the simulator.*

## Development Conventions
- **SwiftUI First:** All UI components should be built using SwiftUI.
- **Modern Swift:** Leverage modern Swift features and follow [Apple's Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/).
- **Standard Formatting:** Follow standard Swift formatting conventions (e.g., 4-space indentation).
