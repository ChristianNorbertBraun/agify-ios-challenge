import OSLog
import SwiftUI

private nonisolated let logger = Logger(subsystem: "AgifyApp", category: "general")

@main
struct AgifyApp: App {
    private static let isMockAPIEnabled = ProcessInfo.processInfo.arguments.contains("-mockAPI")

    private let ageSearch = Self.isMockAPIEnabled
        ? AgeSearchUseCase(client: MockAgifyClient(delay: .seconds(2)))
        : AgeSearchUseCase(client: LiveAgifyClient())

    init() {
        if Self.isMockAPIEnabled {
            logger.info("Mocks enabled")
        }
        ErrorReporter.start()
    }

    var body: some Scene {
        WindowGroup {
            SearchView()
                .environment(\.ageSearch, ageSearch)
        }
    }
}

extension EnvironmentValues {
    @Entry var ageSearch = AgeSearchUseCase(client: MockAgifyClient())
}
