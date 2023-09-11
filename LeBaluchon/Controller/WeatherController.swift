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
                    if let data = data.name {
                        print("City is \(data)")
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
  


