import Foundation

enum MeteoEndpoint {
    case cityLocation(Int)
    
    func url(baseURL: URL) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "/data/2.5/weather"
        switch self {
        case let .cityLocation(id):
            components.queryItems = []
            components.queryItems?.append(.init(name: "id", value: "\(id)"))
            components.queryItems?.append(.init(name: "appid", value: ""))
        }
        return components.url!
    }
}

