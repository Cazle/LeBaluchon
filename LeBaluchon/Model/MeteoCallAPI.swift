import Foundation

enum APIError: Error {
    case invalidData
    case invalidResponse
    case invalidDecoding
    case invalidNameOrCity
    case unknown
}

class MeteoService {
    
    let cityUrl = MeteoEndpoint.cityLocation(0 , 0).url(baseURL: URL(string: "https://api.openweathermap.org")!)
    
    private var client: HTTPClient
    
    
    init(client: HTTPClient = URLSessionHTTPClient(session: URLSession(configuration: .default))) {
        self.client = client
    }
    
    func getTheWeather(callback: @escaping (Result<MeteoModel, APIError>) -> Void) {
        client.request(url: cityUrl) {result in
            switch result {
            case let .success((data, response)):
               callback(.success(self.meteoDatas(data: data, response: response)))
            case .failure(_):
               callback(.failure(APIError.invalidResponse))
            }
        }
    }
    func meteoDatas(data: Data, response: HTTPURLResponse) -> MeteoModel {
        
        let meteoModelEmptyIfNoDecoder = MeteoModel(name: "", weather: [])
     
        guard let decoder = try? JSONDecoder().decode(MeteoModel.self, from: data) else {
            return meteoModelEmptyIfNoDecoder
        }
        let name = decoder.name
        let weather = decoder.weather
        
        let meteoDatas = MeteoModel(name: name, weather: weather)
        return meteoDatas
    }
    
}
