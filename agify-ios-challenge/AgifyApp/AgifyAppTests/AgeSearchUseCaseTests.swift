@testable import AgifyApp
import Testing

struct AgeSearchUseCaseTests {
    @Test(arguments: ["", "   ", "\n"])
    func `blank query never reaches client`(query: String) async throws {
        let search = AgeSearchUseCase(client: UnreachableClient())

        #expect(try await search(query) == nil)
    }

    @Test func `query is trimmed before calling client`() async throws {
        let search = AgeSearchUseCase(client: MockAgifyClient())

        #expect(try await search("  Anna \n")?.name == "Anna")
    }
}

private struct UnreachableClient: AgifyClient {
    func getAgeForName(_ name: String) async throws -> GetAgeForNameResponse {
        Issue.record("Client must not be called, but was called with \"\(name)\"")
        throw CancellationError()
    }
}
