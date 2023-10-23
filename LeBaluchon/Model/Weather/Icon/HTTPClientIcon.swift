import Foundation
protocol HTTPClientIcon {
    func request(url: URL,
                 completion: @escaping (Result <Data, Error>) -> Void)
}
final class URLSessionHTTPClientIcon: HTTPClientIcon {
    
    private let session: URLSession
    
    init(session: URLSession){
        self.session = session
    }
    
    enum SessionError: Error {
        case urlError
        case unexpected
    }
    
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: url) {data, response, error in
            if error != nil {
                completion(.failure(SessionError.urlError))
            }
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
}
