import SwiftUI

extension View {
    /// Like `task(id:)`, but waits `debounce` before running. A new `id` cancels both the wait and a running `action`.
    func task(
        id: some Equatable,
        debounce: Duration,
        _ action: @escaping @isolated(any) @Sendable () async -> Void,
    ) -> some View {
        task(id: id) {
            do {
                try await Task.sleep(for: debounce)
            } catch {
                return
            }
            await action()
        }
    }
}
