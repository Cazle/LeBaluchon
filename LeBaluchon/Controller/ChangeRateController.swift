import Foundation
import UIKit

class ChangeRateController: UIViewController {
    
    @IBOutlet weak var amountOfCurrencyTextView: UITextView!
    
    @IBOutlet weak var amountConvertedCurrencyTextView: UITextView!
    
    let loader = ChangeRateLoader()
   
    @IBAction func tapButtonToGetChangeRate(_ sender: Any) {
        loader.load(eur: "EUR", dollars: "USD", amount: 10) {result in
            switch result {
            case let .success(newRate):
                print(newRate)
            case let .failure(fail):
                print(fail)
            }
        }
    }
    
}
