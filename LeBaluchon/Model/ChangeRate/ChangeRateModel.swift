import Foundation

struct ChangeRateModel: Decodable {
    let success: Bool
    let timestamp: Double
    let base: String
    let date: String
    let rates: [String: Double]
}



