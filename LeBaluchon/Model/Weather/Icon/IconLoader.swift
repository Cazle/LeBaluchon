import Foundation
final class IconLoader {
    private let client: HTTPClientIcon
    
    init(client: HTTPClientIcon = URLSessionHTTPClientIcon(session: URLSession(configuration: .default))) {
        self.client = client
    }
    
    func load(id: String, completion: @escaping  (Result <Data, Error>) -> Void) {
        let url = URL(string: "https://openweathermap.org/img/wn/\(id)@2x.png")!
        client.request(url: url) { result in
                switch result {
                case let .success(data):
                    completion(.success(data))
                case .failure:
                    completion(.failure(APIError.invalidData))
                }
            }
        }
    }




