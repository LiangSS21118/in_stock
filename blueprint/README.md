# Blueprint Index

`blueprint/` stores the visual reference boards for the `in_stock` SwiftUI prototype. Filenames keep the original board order and add the user-facing flow they describe.

| File | Blueprint Scope | Main App Areas |
| --- | --- | --- |
| `01-dashboard-reminders.png` | Home dashboard and reminder system | `DashboardView`, `ReminderCenterView`, `NotificationCard`, `StickerItemCard` |
| `02-spaces-items.png` | Space overview and item display | `SpaceView`, `SpaceDetailView`, `SpaceCard`, `AddPlaceholderCard` |
| `03-add-item-recognition.png` | Add item flow, natural-language input, camera recognition, and confirmation form | `AddItemEntryView`, `NaturalLanguageInputView`, `CameraRecognitionView`, `AddItemConfirmView` |
| `04-lists-shopping-mode.png` | Checklist mode and shopping mode | `ListView`, `ChecklistModeView`, `ShoppingModeView`, `PaperChecklistCard`, `QuantityStepper` |
| `05-declutter-profile.png` | Declutter list, declutter settings, profile, achievements, and milestone card | `DeclutterView`, `DeclutterSettingsView`, `ProfileView`, `AchievementView` |

## Naming Rules

- Keep the two-digit board order prefix so the image sequence stays aligned with the product flow.
- Use lowercase kebab-case after the prefix.
- Prefer feature words over generic labels, for example `dashboard-reminders` instead of `screen-1`.
- When adding new blueprint boards, update this index and `BLUEPRINT_IMPLEMENTATION_REPORT.md` in the same change.

