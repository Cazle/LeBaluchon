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

    @IBAction func testData(_ sender: Any) {
            meteo.getTheWeather { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let meteo):
                            print(meteo)
                        case .failure():
                            self.presentAlert()
                        default:
                            print("Something went wrong")
                    }
                }
            }
    }
}
    


