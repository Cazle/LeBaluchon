//
//  ViewController.swift
//  LeBaluchon
//
//  Created by Kyllian GUILLOT on 05/09/2023.
//

import UIKit

class WeatherController: UIViewController {
    
    @IBOutlet weak var iconPictureMyLocationImageView: UIImageView!
    @IBOutlet weak var cityNameLabelMyLocation: UILabel!
    @IBOutlet weak var skyDescriptionLabelMyLocation: UILabel!
    @IBOutlet weak var climateDescriptionLabelMyLocation: UILabel!
    
    let meteo = MeteoService()
    let loader = MeteoLoader()
    
   override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    func presentAlert() {
        let alertVC = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func testIfDataWork(_ sender: Any) {
        meteo.getTheWeather { (result: Result<MeteoModel, APIError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let name = data.name {
                        self.cityNameLabelMyLocation.text = name
                    }
                    if let weather = data.weather {
                        for weatherDatas in weather {
                            self.skyDescriptionLabelMyLocation.text = weatherDatas.description
                            self.climateDescriptionLabelMyLocation.text = weatherDatas.main
                        }
                    }
                case .failure(let error):
                    print("C'est l'erreur du viewController \(error)")
                }
            }
        }
    }
}
  


