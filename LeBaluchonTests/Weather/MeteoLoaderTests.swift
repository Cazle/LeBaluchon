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
        let exp = expectation(description: "Waiting...")
        
        client.load(id: fakeID()) {result in
            switch result {
            case let .success(data):
                exp.fulfill()
                XCTAssertEqual(data.name, "Zocca")
                for datas in data.weather {
                    XCTAssertEqual(datas.description, "moderate rain")
                    XCTAssertEqual(datas.main, "Rain")
                    XCTAssertEqual(datas.icon, "10d")
                }
            case let .failure(error):
                print("Je suis une erreur", error)
            }
        }
        wait(for: [exp], timeout: 0.2)
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
    func fakeID() -> Int {
        12345
    }
}
