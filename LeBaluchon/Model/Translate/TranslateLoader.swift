import Foundation

final class TranslateLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient(session: URLSession(configuration: .default))) {
        self.client = client
    }
    
    func load(text: String, completion: @escaping (Result<TranslateModel, Error>) -> Void) {
        let url = TranslationEndpoint.translationUrl(text).url(baseURL: URL(string: "https://translation.googleapis.com")!)
        client.request(url: url) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success((data, response)):
                completion(self.decode(data: data, response: response))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    func decode(data: Data, response: HTTPURLResponse) -> Result<TranslateModel, Error> {
        guard response.statusCode == 200 else {
            return .failure(APIError.invalidResponse)
        }
        guard let dataDecoded = try? JSONDecoder().decode(TranslateModel.self, from: data) else {
            return .failure(APIError.invalidDecoding)
        }
        
        return .success(dataDecoded)
    }
}
