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
    
    enum SessionError: Error {
        case urlError
        case unexpected
    }
    
    func request(url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        session.dataTask(with: url) {data, response, error in
            if let error {
                completion(.failure(SessionError.urlError))
                return
            } else if let data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
                return
            } else {
                completion(.failure(SessionError.unexpected))
            }
        }.resume()
    }
}

