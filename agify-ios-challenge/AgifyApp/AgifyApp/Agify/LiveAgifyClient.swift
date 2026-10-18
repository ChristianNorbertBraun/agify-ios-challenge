import Foundation

nonisolated struct LiveAgifyClient: AgifyClient {
    private static let baseURL = URL(string: "https://api.agify.io")!

    @concurrent func getAgeForName(_ name: String) async throws -> GetAgeForNameResponse {
        let url = Self.baseURL.appending(queryItems: [URLQueryItem(name: "name", value: name)])
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        return try Self.response(from: data, urlResponse)
    }

    static func response(from data: Data, _ urlResponse: URLResponse) throws -> GetAgeForNameResponse {
        let httpResponse = urlResponse as? HTTPURLResponse
        switch httpResponse?.statusCode {
        case 200:
            return try JSONDecoder().decode(GetAgeForNameResponse.self, from: data)
        case 429:
            let reset = httpResponse?.value(forHTTPHeaderField: "X-Rate-Limit-Reset")
            throw AgifyError.rateLimited(resetIn: reset.flatMap(Int.init).map { .seconds($0) })
        default:
            throw AgifyError.badResponse(statusCode: httpResponse?.statusCode ?? 0)
        }
    }
}
