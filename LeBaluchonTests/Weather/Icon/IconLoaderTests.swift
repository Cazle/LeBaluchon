import Foundation
import XCTest
@testable import LeBaluchon

final class IconLoaderTests: XCTestCase {
    let tools = Tools()
    func test_whenICallTheAPIAndTheRequestIsASuccess() {
        let clientIconStub = HTTPClientIconStub(result: .success(tools.correctData(data: iconLoaderData)))
        let expectedURL = URL(string: "https://openweathermap.org/img/wn/10d@2x.png")
        let loader = IconLoader(client: clientIconStub)
        
        let exp = expectation(description: "Waiting...")
        loader.load(id: "10d") {result in
            switch result {
            case .success(_):
                exp.fulfill()
                XCTAssertEqual(clientIconStub.calledURL, expectedURL)
            case .failure(_):
                XCTFail("This should not happen")
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
    func test_whenTheURLIsNotMatchingTheCall() {
        let clientIconStub = HTTPClientIconStub(result: .failure(APIError.invalidData))
        let wrongdURL = URL(string: "https://openweathermap.org/img/wn/06d@2x.png")
        let loader = IconLoader(client: clientIconStub)
        
        let exp = expectation(description: "Waiting...")
        loader.load(id: "10d") {result in
            switch result {
            case .success(_):
                XCTFail("This should not happen")
            case let .failure(error):
                exp.fulfill()
                XCTAssertNotEqual(clientIconStub.calledURL, wrongdURL)
                XCTAssertEqual(error as! APIError, .invalidData)
            }
        }
        wait(for: [exp], timeout: 0.2)
    }
}
