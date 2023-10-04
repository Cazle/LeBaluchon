import Foundation

struct ChangeRateModel: Decodable {
    let success: Bool
    struct Query: Decodable {
        let from: String
        let to: String
        let amount: Int
    }
}

