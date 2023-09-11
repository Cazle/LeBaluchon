//
//  ViewController.swift
//  LeBaluchon
//
//  Created by Kyllian GUILLOT on 05/09/2023.
//

import UIKit

class WeatherController: UIViewController {
    
    let meteo = MeteoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                        print("\(name) est le nom de la ville")
                    }
                    if let weather = data.weather {
                        for weatherDatas in weather {
                            print("La description est \(weatherDatas.description), la temps est \(weatherDatas.main), et l'icon est \(weatherDatas.icon)")
                        }
                    }
                case .failure(let error):
                    print("C'est l'erreur du viewController \(error)")
                }
            }
        }
    }
}
  


