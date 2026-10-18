# Decisions, Shortcuts & Ideas

What was decided, which shortcuts were taken for the challenge, and what a production app would do instead.

## Decisions

### Debounce: `.task(id:debounce:)` instead of Combine
A debounce is a delay that restarts on every new value. `.task(id:)` gives that for free: a new query cancels the previous task, whether it is still sleeping (debounce) or already loading (in-flight `URLSession` request is cancelled).
- Combine `debounce` was considered: it only replaces the sleep, still needs `.task(id:)` for cancelling the request, adds state, and building the pipeline in `body` makes the subscription lifetime unclear.
- `AsyncStream` was considered: `debounce` on async sequences needs `swift-async-algorithms` (a dependency), and a `for await` loop does not cancel the previous request.
- The debounce is a UI concern, so it lives in a view modifier, not in the use case.

### Protocol + live/mock clients, use case on top
`AgifyClient` is a protocol (`LiveAgifyClient`, `MockAgifyClient`), `AgeSearchUseCase` holds the input rules (trim, skip blank). This keeps the view free of logic and makes the rules testable without network.

### Concurrency annotations
See CLAUDE.md. Short version: UI on the main actor, services `nonisolated`, real work `@concurrent`.

## Shortcuts → what a production app would do

| Shortcut | Production |
|---|---|
| The network response type `GetAgeForNameResponse` is used all the way up to the views. | A separate app model (e.g. `AgeEstimate`) mapped in `AgeSearchUseCase`, so API changes don't leak into the UI; response types internal to a networking package. |
| Debounce/cancellation behaviour is not unit tested (owned by SwiftUI's `.task(id:)`). | Move search state into an `@Observable` model with an injected `Clock` and test it. |
| No cache: every search costs one of 10 daily requests. | `CachedAgifyClient` decorator (`actor`, in-memory, lowercased keys; errors not cached, "no age" cached) wrapping the live client, possibly plus `URLCache` for persistence and in-flight request deduplication. |
| `ErrorReporter` only logs via `os.Logger`. | Sentry (or similar) started in `App.init`, DSN from an `.xcconfig`, user consent, scrubbing of PII: typed names must not be sent. |
| No API key. | Paid agify key from an `.xcconfig` / secrets, never in the repo. |
| German literals in code, no String Catalog. | `Localizable.xcstrings`, English + German. |
| Generated Info.plist, placeholder bundle ID, empty launch screen. | Real bundle ID, `UILaunchScreen` with brand colour (Info.plist), app icon. |
| Pre-commit hook re-stages whole files (partially staged hunks get committed). | Format in CI / check-only hook, or a tool like `lefthook`. |
| Snapshots for one device, light mode only. | Matrix of devices, dark mode, Dynamic Type sizes; recorded in CI on a pinned simulator. |
| Errors shown as plain text. | Retry action, offline detection, specific copy per error. |

## Ideas (not implemented)
- **Country-specific estimate:** agify supports `country_id` (`?name=michael&country_id=DE` → 54 instead of 57). Use `Locale.current.region`, no location permission needed. Could show "in Deutschland" vs. worldwide.
- **Remaining quota:** show `x-rate-limit-remaining` in the UI.
- **Rolling number on first appearance** is implemented; could also add a count-up for the record count.
- **History** of searched names (SwiftData) and comparing names.
- **Batch request:** agify accepts up to 10 names in one request (`name[]=…`), useful for comparing.
