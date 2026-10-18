import SwiftUI

@main
struct AgifyApp: App {
    init() {
        ErrorReporter.start()
    }

    var body: some Scene {
        WindowGroup {
            Text("Agify")
        }
    }
}
