# Agify iOS Challenge

iOS app that shows the estimated age for a first name using the [agify API](https://agify.io/documentation).
- **Required:** enter a name, see the estimated age.
- **Optional:** an extra feature, a nice design or a UX idea.

## Requirements
- As little code as possible. Simple over clever, no architecture for its own sake, but leave room for new features (a new feature gets its own folder next to `Search/`).
- Idiomatic Swift and SwiftUI. No view models. State lives in views (`@State`, `@Binding`, `@FocusState`). Use `@Observable` (never `ObservableObject`) and `@Bindable` only once state is shared.
- Async work in views via `.task` / `.task(id:)`, never manual `Task {}`.
- Search starts automatically 0.5s after typing stops. A new search cancels the running one.
- Services are protocols or structs, injected via `@Environment` (`@Entry` in `AgifyApp.swift`).
- Network types are named after the operation: `getAgeForName(_:)` returns `GetAgeForNameResponse`. For now the response type is used up to the views (see `DECISIONS.md`).
- No dependencies in the app target. Tooling and test-only packages are fine.
- UI in German. Code, comments and tooling messages in English.
- Comments only where the code isn't self-explanatory.
- Works in portrait and landscape.
- Every shortcut taken for the challenge goes into `DECISIONS.md`, together with what a production app would do instead.

## Structure
```
agify-ios-challenge/AgifyApp/
├── AgifyApp/
│   ├── AgifyApp.swift            entry point, dependency setup, `-mockAPI` switch
│   ├── ErrorReporter.swift       placeholder for error reporting (e.g. Sentry)
│   ├── View+DebouncedTask.swift
│   ├── Agify/                    network: client protocol, live + mock client, response types
│   └── Search/                   use case and views
└── AgifyAppTests/                unit and snapshot tests (Swift Testing)
```

## Concurrency
Swift 6 with default MainActor isolation.
- Views and UI state: main actor (default).
- Models and services: `nonisolated`.
- Network, decoding, I/O: `@concurrent`.
- Shared mutable state: `actor`.

## Build & test
Requires the Xcode 27 beta (`project.xcproj` format).
```sh
export DEVELOPER_DIR=/Applications/Xcode-27.2.0-Beta.app/Contents/Developer
cd agify-ios-challenge/AgifyApp
xcodebuild -project AgifyApp.xcodeproj -scheme AgifyApp \
  -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -skipPackagePluginValidation test
```
- Launch argument `-mockAPI` uses the mock client with a 2s delay (no network, no quota used).
- Previews use the mock client by default.
- Edit the project with `$DEVELOPER_DIR/usr/bin/xcodeproj` where possible; validate manual edits with `xcprojformatter --update AgifyApp.xcodeproj`.

## Tests
- Few and meaningful: unit tests for logic, snapshot tests for styled components. No tests for initializers.
- Snapshots are recorded on a 3× iPhone simulator with iOS 27.0 (e.g. iPhone 18 Pro). Other scales or iOS versions produce diffs. Wrap snapshot views in `.withoutAnimations()`.

## Tooling
- **SwiftLint** runs on every build via the `SwiftLintPlugins` build tool plugin. Config: `agify-ios-challenge/AgifyApp/.swiftlint.yml`.
- **SwiftFormat** runs in the pre-commit hook (`.githooks/pre-commit`). Config: `.swiftformat`. Install with `brew install swiftformat`, then once per clone: `git config core.hooksPath .githooks`.

## agify API
- Free tier: 10 requests per day. HTTP 429 when exceeded, `X-Rate-Limit-Reset` gives the seconds until reset.
- Unknown names return `"age": null`.
