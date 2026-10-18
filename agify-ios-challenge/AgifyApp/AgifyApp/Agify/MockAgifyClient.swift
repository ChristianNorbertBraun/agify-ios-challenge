/// Used by previews, snapshots and the `-mockAPI` launch argument, so demos don't burn the daily agify quota.
nonisolated struct MockAgifyClient: AgifyClient {
    var delay: Duration
    var error: AgifyError?

    init(delay: Duration = .zero, error: AgifyError? = nil) {
        self.delay = delay
        self.error = error
    }

    func getAgeForName(_ name: String) async throws -> GetAgeForNameResponse {
        try await Task.sleep(for: delay)
        if let error {
            throw error
        }
        return GetAgeForNameResponse(name: name, age: 20 + name.count * 4, count: 12345)
    }
}
