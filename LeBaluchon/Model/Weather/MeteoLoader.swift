import Foundation

final class MeteoLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient(session: URLSession(configuration: .default))) {
        self.client = client
    }
    
    func load(id: Int, lang: String, completion: @escaping (Result<MeteoModel, Error>) -> Void) {
        let url = MeteoEndpoint.cityLocation(id, lang).url(baseURL: URL(string: "https://api.openweathermap.org")!)
        client.request(url: url) {[weak self] result in
            guard let self else { return }
            switch result {
            case let .success((data, response)):
                completion(self.decode(data: data, response: response))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    func decode(data: Data, response: HTTPURLResponse) -> Result<MeteoModel, Error> {
        guard response.statusCode == 200 else {
            return .failure(APIError.invalidResponse)
        }
        guard let dataDecoded = try? JSONDecoder().decode(MeteoModel.self, from: data) else {
            return .failure(APIError.invalidDecoding)
        }
        return .success(dataDecoded)
    }
}
