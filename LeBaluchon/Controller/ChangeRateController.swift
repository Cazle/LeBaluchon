import Foundation
import UIKit

final class ChangeRateController: UIViewController {
    
    @IBOutlet weak var amountOfCurrencyTextView: UITextView!
    @IBOutlet weak var amountConvertedCurrencyTextView: UITextView!
    
    private var selectedCurrencyOnThePickerView: String?
    
    private let loader = ChangeRateLoader()
    
    @IBAction func tapButtonToGetChangeRate(_ sender: Any) {
        guard let selectedCurrency = selectedCurrencyOnThePickerView else {
            return
        }
        print(selectedCurrency)
        loader.load(from: "EUR", to: selectedCurrency) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    let dataArray = data.rates
                    guard let currency = dataArray.first?.value else { return }
                    guard let amount = Double(self?.amountOfCurrencyTextView.text ?? "") else { return }
                    guard amount.isNaN == false else {
                        self?.presentAlert(message: "Veuillez rentrer un chiffre ou un nombre.")
                        return
                    }
                    
                    let multiplication = currency * amount
                    let result = String(multiplication)
                    self?.amountConvertedCurrencyTextView.text = result
                    
                case let .failure(fail):
                    print(fail)
                }
            }
        }
    }
}
extension ChangeRateController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allCurrencies.count
    }
}
extension ChangeRateController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currencyNames = Array(allCurrencies.values).sorted()
        return currencyNames[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedName = Array(allCurrencies.values).sorted()[row]
        selectedCurrencyOnThePickerView = allCurrencies.first { $0.value == selectedName }?.key
    }
}
