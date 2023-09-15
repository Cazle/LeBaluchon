//
//  ViewController.swift
//  LeBaluchon
//
//  Created by Kyllian GUILLOT on 05/09/2023.
//

import UIKit

class WeatherController: UIViewController {
    
    
    @IBOutlet weak var laRochelleNameLabel: UILabel!
    @IBOutlet weak var laRochelleSkyLabel: UILabel!
    @IBOutlet weak var laRochelleClimateLabel: UILabel!
    
    @IBOutlet weak var newYorkNameLabel: UILabel!
    @IBOutlet weak var newYorkSkyLabel: UILabel!
    @IBOutlet weak var newYorkClimateLabel: UILabel!
    
    let meteo = MeteoService()
    let loader = MeteoLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingMeteo(lat: 46.167, lon: -1.150, cityName: self.laRochelleNameLabel, skyDescription: self.laRochelleSkyLabel, climateDescription: self.laRochelleClimateLabel)
        loadingMeteo(lat: 40.7143, lon: -74.006, cityName: self.newYorkNameLabel, skyDescription: self.newYorkSkyLabel, climateDescription: self.newYorkClimateLabel)
    }
    func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func loadingMeteo(lat: Double, lon: Double, cityName: UILabel, skyDescription: UILabel, climateDescription: UILabel) {
        loader.load(lat: lat, lon: lon) {result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let name = data.name {
                        cityName.text = name
                    }
                    if let weather = data.weather {
                        for weatherDatas in weather {
                            skyDescription.text = weatherDatas.description
                            climateDescription.text = weatherDatas.main
                        }
                    }
                case .failure(let error):
                    self.presentAlert()
                    print("C'est l'erreur du viewController \(error)")
                }
            }
        }
    }
}
                    


