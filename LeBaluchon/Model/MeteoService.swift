import Foundation

enum APIError: Error {
    case invalidData
    case invalidResponse
    case invalidNameOrCity
    case unknown
}

class MeteoService {
    
    private static let APIKEY = "2d397b17f22bb4d362b3afe34a85dddb"
    private static let lat = "46.167"
    private static let lon = "-1.150"
    private static let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(APIKEY)")!
    
    private var task: URLSessionDataTask?
    private var meteoSession: URLSession
    
    init(meteoSession: URLSession = URLSession (configuration: .default)) {
        self.meteoSession = meteoSession
    }
    
    func getTheWeather(callback: @escaping (Result<MeteoModel, APIError>) -> Void) {
        let request = URLRequest(url: MeteoService.url)
        
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
