import Foundation
import XCTest
@testable import LeBaluchon

final class MeteoLoaderTests: XCTestCase {
    let tools = Tools()
    
    func test_whenICallTheAPIAndTheRequestIsASuccess() {
        let clientStub = ClientStub(
            result: .success((tools.correctData(data: weatherDatas),
                              tools.correctResponse())))
        
        let client = MeteoLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(id: 1, lang: "fr") {result in
            switch result {
            case let .success(data):
                exp.fulfill()
                XCTAssertEqual(data.name, "Zocca")
                XCTAssertEqual(data.weather[0].description, "moderate rain")
                XCTAssertEqual(data.weather[0].main, "Rain")
                XCTAssertEqual(data.weather[0].icon, "10d")
            case .failure(_):
                XCTFail("This should not happen")
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
    func test_whenDataIsNotCorrectAndTheLoaderExpectTheCorrectData() {
        let clientStub = ClientStub(result: 
                .success((tools.uncorrrectData(),
                          tools.correctResponse())))
        
        let client = MeteoLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(id: 1, lang: "fr") {result in
            switch result {
            case .success(_):
                XCTFail("This should not happen")
            case let .failure(error):
                exp.fulfill()
                XCTAssertEqual(error as! APIError, .invalidDecoding)
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
    func test_whenThereIsDataButTheResponseIsFailing() {
        let clientStub = ClientStub(result: 
                .success((tools.correctData(data: weatherDatas),
                          tools.uncorrectResponse())))
        
        let client = MeteoLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(id: 1, lang: "fr") {result in
            switch result {
            case .success(_):
                XCTFail("This should not happen")
            case let .failure(error):
                exp.fulfill()
                XCTAssertEqual(error as! APIError, .invalidResponse)
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
    func test_whenThereIsNoDataAndNoResponse() {
        let clientStub = ClientStub(result: .failure(APIError.unknown))
        
        let client = MeteoLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(id: 1, lang: "fr") {result in
            switch result {
            case .success(_):
                XCTFail("This should not happen")
            case let .failure(error):
                exp.fulfill()
                XCTAssertEqual(error as! APIError, .unknown)
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
}
