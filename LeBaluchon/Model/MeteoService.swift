import Foundation

enum APIError: Error {
    case invalidData
    case invalidResponse
    case invalidNameOrCity
    case unknown
}

class MeteoService {
    
    let LaRochelleURL = MeteoEndpoint.LaRochelle(46.167, -1.150).url(baseURL: URL(string: "https://api.openweathermap.org")!)
    
    private var task: URLSessionDataTask?
    private var meteoSession: URLSession
    
    init(meteoSession: URLSession = URLSession (configuration: .default)) {
        self.meteoSession = meteoSession
    }
    
    func getTheWeather(callback: @escaping (Result<MeteoModel, APIError>) -> Void) {
        let request = URLRequest(url: LaRochelleURL)
        
        task?.cancel()
        
        task = meteoSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(.failure(.invalidData))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(.failure(.invalidResponse))
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(MeteoModel.self, from: data) else {
                    callback(.failure(.invalidResponse))
                    return
                }
                guard let name = responseJSON.name, let weatherDescription = responseJSON.weather else {
                    callback(.failure(.invalidNameOrCity))
                    return
                }
               
                
                let meteo = MeteoModel(name: name, weather: weatherDescription)
                callback(.success(meteo))
            }
        }
        task?.resume()
        print(task!)
    }
}
