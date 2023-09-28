import UIKit

class WeatherController: UIViewController {
    
    @IBOutlet weak var laRochelleNameLabel: UILabel!
    @IBOutlet weak var laRochelleSkyLabel: UILabel!
    @IBOutlet weak var laRochelleClimateLabel: UILabel!
    @IBOutlet weak var laRochelleIconImage: UIImageView!
    
    @IBOutlet weak var newYorkNameLabel: UILabel!
    @IBOutlet weak var newYorkSkyLabel: UILabel!
    @IBOutlet weak var newYorkClimateLabel: UILabel!
    @IBOutlet weak var newYorkCityIconImage: UIImageView!
    
    let loader = MeteoLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            self.loadingMeteo(lat: 46.167,
                              lon: -1.150,
                              cityName: self.laRochelleNameLabel,
                              skyDescription: self.laRochelleSkyLabel,
                              climateDescription: self.laRochelleClimateLabel,
                              icon: self.laRochelleIconImage)
            group.leave()
        }
        group.enter()
        DispatchQueue.global().async {
            self.loadingMeteo(lat: 40.7143,
                              lon: -74.006,
                              cityName: self.newYorkNameLabel,
                              skyDescription: self.newYorkSkyLabel,
                              climateDescription: self.newYorkClimateLabel,
                              icon: self.newYorkCityIconImage)
            group.leave()
        }
        group.notify(queue: .main) {
            print("All loaded")
        }
    }
    func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func loadingMeteo(lat: Double, lon: Double, cityName: UILabel, skyDescription: UILabel, climateDescription: UILabel, icon: UIImageView) {
        loader.load(lat: lat, lon: lon) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let name = data.name
                        cityName.text = name
                    let weather = data.weather
                        for weatherDatas in weather {
                            skyDescription.text = weatherDatas.description
                            climateDescription.text = weatherDatas.main
                            self?.gettingTheIconImage(id: weatherDatas.icon) {img in
                                icon.image = img
                            }
                        }
                case .failure(let error):
                    self?.presentAlert()
                    print("C'est l'erreur du viewController \(error)")
                }
            }
        }
    }
    func gettingTheIconImage(id: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: "https://openweathermap.org/img/wn/\(id)@2x.png")!
        URLSession.shared.dataTask(with: url) {data, response, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }.resume()
    }
}



