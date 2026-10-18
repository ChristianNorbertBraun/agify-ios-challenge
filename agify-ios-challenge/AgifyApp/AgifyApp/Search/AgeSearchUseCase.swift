import Foundation

nonisolated struct AgeSearchUseCase: Sendable {
    let client: any AgifyClient

    /// Returns `nil` for a blank query without calling the API.
    func callAsFunction(_ query: String) async throws -> GetAgeForNameResponse? {
        let name = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else {
            return nil
        }
        return try await client.getAgeForName(name)
    }
}
