import XCTest
@testable import LeBaluchon

final class HTTPClientTests: XCTestCase {
    
    func test_requestFails_thenErrorIsLaunched() {
        let sut = makeSUT()
        let expectedError = errorForTests()
        
        URLProtocolStub.stub(data: nil, response: nil, error: expectedError)
        let exp = expectation(description: "Wait...")
        
        sut.request(url: urlForTests()) {result in
            guard case let .failure(error) = result else {
                XCTFail("Expected Failure")
                return
            }
            exp.fulfill()
            XCTAssertEqual(error as NSError, expectedError)
        }
        wait(for: [exp], timeout: 0.1)
        URLProtocolStub.removeStub() //Reset the Stub
    }
    
    func test_requestSucceed() {
        let sut = makeSUT()
        let response = responseForTests()
        let data = dataForTests()
        
        URLProtocolStub.stub(data: data, response: response, error: nil)
        let exp = expectation(description: "Wait...")
        
        sut.request(url: urlForTests()) {result in
            guard case let .success((receivedData, receivedResponse)) = result else {
                XCTFail("Unexpected Failure")
                return
            }
            exp.fulfill()
            XCTAssertEqual(receivedData, data)
            XCTAssertEqual(receivedResponse, response)
        }
        wait(for: [exp], timeout: 0.1)
        URLProtocolStub.removeStub() //Reset Stub
    }
    func test_whenThereIsNoRequestAtAllWithNoDataAndNoResponse() {
        let sut = makeSUT()
        
        URLProtocolStub.stub(data: nil, response: nil, error: nil)
        let exp = expectation(description: "Wait...")
        
        sut.request(url: urlForTests()) {result in
            guard case let .failure(error) = result else {
                XCTFail("Unexpected Failure")
                return
            }
            exp.fulfill()
            XCTAssertTrue(error is UnexpectedError)
        }
        wait(for: [exp], timeout: 0.1)
        URLProtocolStub.removeStub() //Reset Stub
    }
}


private func makeSUT() -> URLSessionHTTPClient {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [URLProtocolStub.self]
    let session = URLSession(configuration: configuration)
    let sut = URLSessionHTTPClient(session: session)
    return sut
}
private func errorForTests() -> NSError {
    NSError(domain: "Random Error", code: 1)
}
private func urlForTests() -> URL {
    URL(string: "https://www.apple.com")!
}
private func dataForTests() -> Data {
    Data("Some Datas".utf8)
}
private func responseForTests() -> HTTPURLResponse {
    HTTPURLResponse(url: URL(string: "https://www.apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
}
private struct UnexpectedError: Error {}

