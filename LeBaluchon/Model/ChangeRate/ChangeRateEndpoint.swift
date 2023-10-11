import Foundation

enum ChangeRateEndpoint {
    case convertCurrency(String, String)
    
    func url(baseURL: URL) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "/latest"
        switch self {
        case let .convertCurrency(from, to):
            components.queryItems = []
            components.queryItems?.append(.init(name: "access_key", value: ""))
            components.queryItems?.append(.init(name: "base", value: "\(from)"))
            components.queryItems?.append(.init(name: "symbols", value: "\(to)"))
            
        }
        return components.url!
    }
}
