import Foundation

protocol HTTPClient {
    func request(url: URL,
                 completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void)
}

final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession){
        self.session = session
    }
    
    struct UnexpectedError: Error {}
    
    func request(url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        session.dataTask(with: url) {data, response, error in
            if let error {
                completion(.failure(error))
                return
            } else if let data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
                return
            } else {
                completion(.failure(UnexpectedError()))
            }
        }.resume()
    }
}
    
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

