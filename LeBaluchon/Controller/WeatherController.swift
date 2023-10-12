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
            self.loadingMeteo(id: 3006787,
                              cityName: self.laRochelleNameLabel,
                              skyDescription: self.laRochelleSkyLabel,
                              climateDescription: self.laRochelleClimateLabel,
                              icon: self.laRochelleIconImage)
            group.leave()
        }
        group.enter()
        DispatchQueue.global().async {
            self.loadingMeteo(id: 5128581,
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
    
    func loadingMeteo(id: Int, cityName: UILabel, skyDescription: UILabel, climateDescription: UILabel, icon: UIImageView) {
        loader.load(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let name = data.name
                        cityName.text = name
                    let weather = data.weather
                        for weatherDatas in weather {
                            skyDescription.text = weatherDatas.description
                            climateDescription.text = weatherDatas.main
                            getIconImage(id: weatherDatas.icon) {result in
                                switch result {
                                case let .success(image):
                                    let img = UIImage(data: image)
                                    icon.image = img
                                case .failure(_):
                                    self?.presentAlert()
                                }
                            }
                        }
                case .failure(let error):
                    self?.presentAlert()
                    print("C'est l'erreur du viewController \(error)")
                }
            }
        }
    }
}



