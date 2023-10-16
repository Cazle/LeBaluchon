import Foundation
import XCTest
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
class MeteoLoaderTests: XCTestCase {
    
    func test_whenICallTheAPIAndTheRequestIsASuccess() {
        let clientStub = ClientStub(result: .success((correctData(), correctResponse())))
        
        let client = MeteoLoader(client: clientStub)
        print(clientStub.result)
        
        client.load(id: 1) {result in
            switch result {
            case let .success(data):
                print("Je suis un succès",data)
            case let .failure(error):
                print("Je suis une erreur", error)
            }
        }
    }
    func correctData() -> Data {
        Data(WeatherDatas.utf8)
    }
    func correctResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: correctURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    func correctURL() -> URL {
        URL(string: "https://apple.com")!
    }
}
