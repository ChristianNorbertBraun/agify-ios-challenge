@testable import AgifyApp
import Foundation
import Testing

struct LiveAgifyClientTests {
    @Test func `unknown name decodes without age`() throws {
        let data = Data(#"{"count":0,"name":"xqzvbn","age":null}"#.utf8)

        let response = try LiveAgifyClient.response(from: data, httpResponse(statusCode: 200))

        #expect(response.age == nil)
    }

    @Test func `too many requests throws rate limited with reset time`() {
        let httpResponse = httpResponse(statusCode: 429, headers: ["X-Rate-Limit-Reset": "8568"])

        #expect(throws: AgifyError.rateLimited(resetIn: .seconds(8568))) {
            try LiveAgifyClient.response(from: Data(), httpResponse)
        }
    }

    private func httpResponse(statusCode: Int, headers: [String: String] = [:]) -> HTTPURLResponse {
        HTTPURLResponse(
            url: URL(string: "https://api.agify.io")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: headers,
        )!
    }
}
