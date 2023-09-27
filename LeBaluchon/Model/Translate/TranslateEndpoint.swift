import Foundation

enum TranslationEndpoint {
    case translationUrl(String)
    
    func url(baseURL: URL) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = "/language/translate/v2"
        
        switch self {
        case let .translationUrl(value):
            components.queryItems = []
            components.queryItems?.append(.init(name: "key", value: ""))
            components.queryItems?.append(.init(name: "q", value: "\(value)"))
            components.queryItems?.append(.init(name: "source", value: "fr"))
            components.queryItems?.append(.init(name: "target", value: "en"))
            components.queryItems?.append(.init(name: "format", value: "text"))
        }
        return components.url!
    }
}
