import Foundation
import XCTest
@testable import LeBaluchon

final class ChangeRateLoaderTests: XCTestCase {
    let tools = Tools()
    func test_whenICallTheAPIAndTheRequestIsASuccess() {
        let clientStub = ClientStub(
            result: .success(((tools.correctData(data: changeRateData)),
                              tools.correctResponse())))
        let loader = ChangeRateLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        loader.load(from: "EUR", to: "USD") {result in
            switch result {
            case let .success(change):
                exp.fulfill()
                XCTAssertEqual(change.success, true)
                XCTAssertEqual(change.timestamp, 1519296206)
                XCTAssertEqual(change.base, "EUR")
                XCTAssertEqual(change.date, "2023-10-04")
                XCTAssertEqual(change.rates.first?.value, 1.23396)
                XCTAssertEqual(change.rates.first?.key, "USD")
            case .failure(_):
                XCTFail("This should not happen")
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
    func test_whenDataIsNotCorrectAndTheLoaderExpectTheCorrectData() {
        let clientStub = ClientStub(
            result: .success((tools.uncorrrectData(),
                              tools.correctResponse())))
        
        let client = ChangeRateLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(from: "EUR", to: "USD") {result in
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
        let clientStub = ClientStub(
            result: .success((tools.correctData(data: changeRateData),
                              tools.uncorrectResponse())))
        
        let client = ChangeRateLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(from: "EUR", to: "USD") {result in
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
        
        let client = ChangeRateLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(from: "EUR", to: "USD") {result in
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
