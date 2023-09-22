import Foundation

class TranslateCallAPI {
    
    let client: HTTPClient
    
    init(client: HTTPClient = URLSessionHTTPClient(session: URLSession(configuration: .default))) {
        self.client = client
    }
    
    let url = TranslationEndpoint.translationUrl("Je m'appelle Kyllian").url(baseURL: URL(string: "https://translation.googleapis.com")!)
    func testAPI(url: URL, completion: @escaping (Result<TranslateModel, APIError>) -> Void) {
        client.request(url: url) {result in
            switch result {
            case let .success((data, response)):
                completion(.success(self.analyzeDatasFromTranslateAPI(data: data, response: response)))
            case let .failure(error):
                print(error, "Je suis une erreur model")
            }
        }
    }
    private func analyzeDatasFromTranslateAPI(data: Data, response: HTTPURLResponse) -> TranslateModel {
        
        let emptyModel = TranslateModel(datas: [])
        
        guard let decoder = try? JSONDecoder().decode(TranslateModel.self, from: data) else{
            return emptyModel
        }
        for datas in decoder.datas {
            datas.translation.translatedText
            print(datas.translation.translatedText)
            print(datas.translation)
        }
        print(decoder)
        return decoder
    }
}
