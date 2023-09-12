import Foundation

final class MeteoLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(url: URL, completion: @escaping (Result<MeteoModel, Error>) -> Void) {
        client.request(url: url) { result in
            switch result {
            case let .success((data, response)):
                completion(self.decode(data: data, response: response))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    private func decode(data: Data, response: HTTPURLResponse) -> Result<MeteoModel, Error> {
        guard response.statusCode == 200 else {
            return .failure(APIError.invalidResponse)
        }
        guard let dataDecoded = try? JSONDecoder().decode(MeteoModel.self, from: data) else {
            return .failure(APIError.unknown)
        }
        return .success(dataDecoded)
    }
}
