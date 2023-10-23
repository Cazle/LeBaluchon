import Foundation
import XCTest
@testable import LeBaluchon

final class HTTPClientIconTests: XCTestCase {
    
    func test_callFails_thenErrorIsLaunched() {
        let sut = makeSUT()
        let wrongURL = errorForTests()
        
        URLProtocolStub.stub(data: nil, response: nil, error: wrongURL)
        let exp = expectation(description: "Wait...")
        
        sut.request(url: urlForTests()) {result in
            guard case let .failure(error) = result else {
                XCTFail("Unexpected Failure")
                return
            }
            exp.fulfill()
            XCTAssertEqual(error as! URLSessionHTTPClientIcon.SessionError, .urlError)
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    func test_requestSucceed() {
        let sut = makeSUT()
        let data = dataForTests()
        
        URLProtocolStub.stub(data: data, response: nil, error: nil)
        let exp = expectation(description: "Wait...")
        
        sut.request(url: urlForTests()) {result in
            guard case let .success(receivedData) = result else {
                XCTFail("Unexpected failure")
                return
            }
            exp.fulfill()
            XCTAssertEqual(receivedData, data)
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    private func makeSUT() -> URLSessionHTTPClientIcon {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClientIcon(session: session)
        return sut
    }
    private func errorForTests() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    private func urlForTests() -> URL {
        URL(string: "https://www.apple.com")!
    }
    private func dataForTests() -> Data {
        Data("Some Datas".utf8)
    }
}
