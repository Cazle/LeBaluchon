import Foundation
@testable import LeBaluchon

final class HTTPClientIconStub: HTTPClientIcon {
    
    let result: (Result<Data, Error>)
    var calledURL: URL?
    
    init(result: Result<Data, Error>) {
        self.result = result
    }
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        calledURL = url
        completion(result)
    }
}
