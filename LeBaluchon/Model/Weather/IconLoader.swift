import Foundation

func getIconImage(id: String, completion: @escaping (Result<Data, Error>) -> Void) {
    let url = URL(string: "https://openweathermap.org/img/wn/\(id)@2x.png")!
    URLSession.shared.dataTask(with: url) {data, response, error in
        DispatchQueue.main.async {
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(APIError.unknown))
            }
        }
    }.resume()
}


