import Foundation

protocol AgifyClient: Sendable {
    func getAgeForName(_ name: String) async throws -> GetAgeForNameResponse
}

nonisolated enum AgifyError: LocalizedError, Equatable {
    case rateLimited(resetIn: Duration?)
    case badResponse(statusCode: Int)

    var errorDescription: String? {
        switch self {
        case let .rateLimited(resetIn?):
            let time = resetIn.formatted(.units(allowed: [.hours, .minutes], width: .wide))
            return "Das Requestlimit von agify ist erreicht. Versuche es in \(time) erneut."
        case .rateLimited:
            return "Das Requestlimit von agify ist erreicht. Versuche es später erneut."
        case .badResponse:
            return "agify hat unerwartet geantwortet. Bitte versuche es erneut."
        }
    }
}
