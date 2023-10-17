import UIKit


final class WeatherController: UIViewController {
    
    @IBOutlet weak var laRochelleNameLabel: UILabel!
    @IBOutlet weak var laRochelleSkyLabel: UILabel!
    @IBOutlet weak var laRochelleClimateLabel: UILabel!
    @IBOutlet weak var laRochelleIconImage: UIImageView!
    
    @IBOutlet weak var newYorkNameLabel: UILabel!
    @IBOutlet weak var newYorkSkyLabel: UILabel!
    @IBOutlet weak var newYorkClimateLabel: UILabel!
    @IBOutlet weak var newYorkCityIconImage: UIImageView!
    
    private let loader = MeteoLoader()
    let iconLoader = IconLoader()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            self.loadingMeteo(id: 3006787,
                              lang: "fr",
                              cityName: self.laRochelleNameLabel,
                              skyDescription: self.laRochelleSkyLabel,
                              climateDescription: self.laRochelleClimateLabel,
                              icon: self.laRochelleIconImage)
            group.leave()
        }
        group.enter()
        DispatchQueue.global().async {
            self.loadingMeteo(id: 5128581,
                              lang: "fr",
                              cityName: self.newYorkNameLabel,
                              skyDescription: self.newYorkSkyLabel,
                              climateDescription: self.newYorkClimateLabel,
                              icon: self.newYorkCityIconImage)
            group.leave()
        }
    }
    
    private func loadingMeteo(id: Int, lang: String, cityName: UILabel, skyDescription: UILabel, climateDescription: UILabel, icon: UIImageView) {
        loader.load(id: id, lang: lang) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    let name = data.name
                        cityName.text = name
                    let weather = data.weather
                            skyDescription.text = weather[0].description
                            climateDescription.text = weather[0].main
                    self?.iconLoader.load(id: weather[0].icon) {result in
                                switch result {
                                case let .success(image):
                                    let img = UIImage(data: image)
                                    icon.image = img
                                case .failure(_):
                                    self?.presentAlert(message: "Une erreur s'est produite dans la récupération de l'icône")
                                }
                            }
                        
                case .failure(_):
                    self?.presentAlert(message: "Une erreur s'est produite.")
                }
            }
        }
    }
}



