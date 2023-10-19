import Foundation
@testable import LeBaluchon

class ClientStub: HTTPClient {
    let result: Result<(Data, HTTPURLResponse), Error>
    
    init(result: Result<(Data, HTTPURLResponse), Error>) {
        self.result = result
    }
    func request(url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        completion(result)
    }
}
