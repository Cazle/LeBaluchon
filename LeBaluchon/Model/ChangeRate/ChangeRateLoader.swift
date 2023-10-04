import Foundation

final class ChangeRateLoader {
    private let client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient(session: URLSession(configuration: .default))) {
        self.client = client
    }
    
    func load(eur: String, dollars: String, amount: Int, completion: @escaping (Result<ChangeRateModel, Error>) -> Void) {
        let url = ChangeRateEndpoint.euroToDollars(eur, dollars, amount).url(baseURL: URL(string: "http://data.fixer.io/api")!)
        client.request(url: url) { result in
            switch result {
            case let .success((data, response)):
                completion(self.decode(data: data, response: response))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    func decode(data: Data, response: HTTPURLResponse) -> Result<ChangeRateModel, Error> {
        guard response.statusCode == 200 else {
            return .failure(APIError.invalidResponse)
        }
        guard let dataDecoded = try? JSONDecoder().decode(ChangeRateModel.self, from: data) else {
            return .failure(APIError.invalidDecoding)
        }
        
        return .success(dataDecoded)
    }
}
