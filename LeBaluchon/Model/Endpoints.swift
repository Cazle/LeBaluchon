import Foundation

enum MeteoEndpoint {
    case laRochelle(Double, Double)
    
    func url(baseURL: URL) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "/data/2.5/weather"
        switch self {
        case let .laRochelle(lat, lon):
            components.queryItems = []
            components.queryItems?.append(.init(name: "lat", value: "\(lat)"))
            components.queryItems?.append(.init(name: "lon", value: "\(lon)"))
            components.queryItems?.append(.init(name: "appid", value: "2d397b17f22bb4d362b3afe34a85dddb"))
        }
        return components.url!
    }
}
