import Foundation

enum ChangeRateEndpoint {
    case euroToDollars(String, String, Int)
    
    func url(baseURL: URL) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "/convert"
        switch self {
        case let .euroToDollars(eur, dollars, amount):
            components.queryItems = []
            components.queryItems?.append(.init(name: "access_key", value: ""))
            components.queryItems?.append(.init(name: "from", value: "\(eur)"))
            components.queryItems?.append(.init(name: "to", value: "\(dollars)"))
            components.queryItems?.append(.init(name: "amount", value: "\(amount)"))
            
        }
        return components.url!
    }
}
