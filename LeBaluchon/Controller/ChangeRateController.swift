import Foundation
import UIKit

class ChangeRateController: UIViewController {
    
    @IBOutlet weak var amountOfCurrencyTextView: UITextView!
    @IBOutlet weak var amountConvertedCurrencyTextView: UITextView!
    
    let loader = ChangeRateLoader()
    
    @IBAction func tapButtonToGetChangeRate(_ sender: Any) {
        loader.load(from: "EUR", to: "USD") { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    let dataArray = data.rates
                    guard let currency = dataArray.first?.value else { return }
                    print(currency)
                    
                    guard let amount = Double(self.amountOfCurrencyTextView.text) else { return }
                    print(amount)
                    let multiplication = currency * amount
                    let result = String(multiplication)
                    
                    self.amountConvertedCurrencyTextView.text = result
                    
                    
                case let .failure(fail):
                    print(fail)
                }
            }
        }
    }
}
