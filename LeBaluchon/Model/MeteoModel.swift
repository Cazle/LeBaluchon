import Foundation

struct MeteoModel: Decodable {

    let name: String?
    
    struct Weather: Codable {
        let main: String
        let description: String
        let icon: String
    }
    let weather: [Weather]?
    
}
