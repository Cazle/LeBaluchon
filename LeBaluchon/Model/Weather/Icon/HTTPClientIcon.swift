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
                return
            } else if let data {
                completion(.success(data))
                return
            } else {
                completion(.failure(SessionError.unexpected))
            }
        }.resume()
    }
}
