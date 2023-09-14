import Foundation

enum APIError: Error {
    case invalidData
    case invalidResponse
    case invalidDecoding
    case invalidNameOrCity
    case unknown
}

class MeteoService {
    
    let LaRochelleURL = MeteoEndpoint.LaRochelle(46.167, -1.150).url(baseURL: URL(string: "https://api.openweathermap.org")!)
    
    private var task: URLSessionDataTask?
    private var meteoSession: URLSession
    private var client: URLSessionHTTPClient
    
    init(meteoSession: URLSession = URLSession (configuration: .default), client: URLSessionHTTPClient) {
        self.meteoSession = meteoSession
        self.client = client
    }
    
    func getTheWeather(callback: @escaping (Result<MeteoModel, APIError>) -> Void) {
        client.request(url: LaRochelleURL) {result in
            print("oui")
        }

    }
}
