import Foundation

final class Tools {
    func uncorrectResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: uncorrectURL(), statusCode: 500, httpVersion: nil, headerFields: nil)!
    }
    func correctResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: correctURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    func uncorrectURL() -> URL {
        URL(string: "Wrong URL")!
    }
    func correctURL() -> URL {
        URL(string: "https://apple.com")!
    }
    func uncorrrectData() -> Data {
        Data("Wrong Data".utf8)
    }
    func correctData(data: String) -> Data {
        Data(data.utf8)
    }
}
