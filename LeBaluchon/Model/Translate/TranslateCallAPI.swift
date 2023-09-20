import Foundation

class TranslateCallAPI {
    
    let client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient(session: URLSession(configuration: .default))) {
        self.client = client
    }
    
    let url = TranslationEndpoint.translationUrl.url(baseURL: URL(string: "https://translation.googleapis.com")!, textToTranslate: "Je m'appelle Kyllian")
    
    func testAPI(url: URL, completion: @escaping (Result<TranslateModel, APIError>) -> Void) {
        client.request(url: url) {result in
            switch result {
            case let .success(data):
                completion(.success(TranslateModel))
            case let .failure(error):
                print(error)
            }
        }
    }
}
