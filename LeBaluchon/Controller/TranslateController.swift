import UIKit

final class TranslateController: UIViewController{
    
    @IBOutlet weak var textToTranslateTextView: UITextView!
    @IBOutlet weak var textTranslatedTextView: UITextView!

    private let translate = TranslateLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func translateButton(_ sender: UIButton) {
        guard let textToTranslate = textToTranslateTextView.text else {
            self.presentAlert(message: "Something wrong happened, please try again.")
            return
        }
        guard textToTranslate.isEmpty == false else {
            self.presentAlert(message: "Please, you have to write some text in the top square.")
            return
        }
        translate.load(text: "\(textToTranslate)") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(translation):
                    let translatedDatas = translation.data
                    let arrayOfTranslations = translatedDatas.translations
                    self?.textTranslatedTextView.text = arrayOfTranslations[0].translatedText
                    
                case .failure:
                    self?.presentAlert(message: "Une erreur s'est produite pendant la récupération des données.")
                }
            }
        }
    }
}
