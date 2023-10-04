import Foundation

struct ChangeRateModel: Decodable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Int]
}
