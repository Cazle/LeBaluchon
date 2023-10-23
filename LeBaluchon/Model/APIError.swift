import Foundation

enum APIError: Error {
    case invalidData
    case invalidResponse
    case invalidDecoding
    case unknown
}

