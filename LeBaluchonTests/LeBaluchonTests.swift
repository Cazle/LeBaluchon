import XCTest
@testable import LeBaluchon

final class LeBaluchonTests: XCTestCase {
    
    func test_requestFails_thenErrorIsLaunched() {
        let sut = makeSUT()
        let expectedError = throwAnError()
        
        URLProtocolStub.stub(data: nil, response: nil, error: expectedError)
        let exp = expectation(description: "Wait...")
        
        sut.request(url: URLForTests()) {result in
            guard case let .failure(error) = result else {
                XCTFail("Expected Failure")
                return
            }
            exp.fulfill()
            XCTAssertEqual(error as NSError, expectedError)
        }
        wait(for: [exp], timeout: 0.1)
    }
}


private func makeSUT() -> URLSessionHTTPClient {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolStub.self]
    let session = URLSession(configuration: configuration)
    let sut = URLSessionHTTPClient(session: session)
    return sut
}
private func throwAnError() -> NSError {
    let expectedError = NSError(domain: "Random Error", code: 0)
    return expectedError
}
private func URLForTests() -> URL {
    URL(string: "https://www.apple.com")!
}
private func DataForTests() -> Data {
    Data("Some Datas".utf8)
}
