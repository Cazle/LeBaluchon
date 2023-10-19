import Foundation
import XCTest
@testable import LeBaluchon

final class TranslateLoaderTests: XCTestCase {
    
    let tools = Tools()
    func test_whenICallTheAPIAndTheRequestIsASuccess() {
        let clientStub = ClientStub(
            result: .success((tools.correctData(data: translateData),
                              tools.correctResponse())))
        
        let client = TranslateLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(text: "My name is Bobby The Clown") {result in
            switch result {
            case let .success(translate):
                exp.fulfill()
                let data = translate.data
                let translations = data.translations
                let translated = translations[0].translatedText
                XCTAssertEqual(translated, "Je m'appelle Bobby Le clown")
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
        
        let client = TranslateLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(text: "My name is Bobby The Clown") {result in
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
            result: .success((tools.correctData(data: translateData),
                              tools.uncorrectResponse())))
        
        let client = TranslateLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(text: "My name is Bobby The Clown") {result in
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
        
        let client = TranslateLoader(client: clientStub)
        let exp = expectation(description: "Waiting...")
        
        client.load(text: "My name is Bobby The Clown") {result in
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
