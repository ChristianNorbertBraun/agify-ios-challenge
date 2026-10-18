import OSLog

/// Stand-in for an error reporting SDK such as Sentry. See DECISIONS.md.
enum ErrorReporter {
    private static let logger = Logger(subsystem: "AgifyApp", category: "errors")

    static func start() {
        logger.info("Error reporting started")
    }

    static func capture(_ error: any Error) {
        logger.error("\(String(describing: error))")
    }
}
