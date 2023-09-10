import Foundation

enum APIError: Error {
    case invalidData
    case invalidResponse
    case invalidNameOrCity
    case unknown
}

class MeteoService {
    
    private static let openWeatherAPIURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid={2d397b17f22bb4d362b3afe34a85dddb}")!
    
    private var task: URLSessionDataTask?
    private var meteoSession: URLSession
    
    init(meteoSession: URLSession = URLSession (configuration: .default)) {
        self.meteoSession = meteoSession
    }
    
    func getTheWeather(callback: @escaping (Result<Meteo, APIError>) -> Void) {
        let request = URLRequest(url: MeteoService.openWeatherAPIURL)
        
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
                guard let responseJSON = try? JSONDecoder().decode([String : String].self, from: data) else {
                    callback(.failure(.invalidResponse))
                    return
                }
                guard let name = responseJSON["name"] else {
                    callback(.failure(.invalidNameOrCity))
                    return
                }
                
                let meteo = Meteo(cityName: name)
                callback(.success(meteo))
            }
        }
        task?.resume()
        print(task!)
    }
}
