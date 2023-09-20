import Foundation

enum MeteoEndpoint {
    case cityLocation(Double, Double)
    
    func url(baseURL: URL) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "/data/2.5/weather"
        switch self {
        case let .cityLocation(lat, lon):
            components.queryItems = []
            components.queryItems?.append(.init(name: "lat", value: "\(lat)"))
            components.queryItems?.append(.init(name: "lon", value: "\(lon)"))
            components.queryItems?.append(.init(name: "appid", value: "2d397b17f22bb4d362b3afe34a85dddb"))
        }
        return components.url!
    }
}

enum TranslationEndpoint {
    case translationUrl
    
    func url(baseURL: URL, textToTranslate: String) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "/language/translate/v2"
        
        switch self {
        case .translationUrl:
            components.queryItems = []
            components.queryItems?.append(.init(name: "key", value: ""))
            components.queryItems?.append(.init(name: "q", value: "\(textToTranslate)"))
            components.queryItems?.append(.init(name: "en", value: "en"))
        }
        return components.url!
    }
}
