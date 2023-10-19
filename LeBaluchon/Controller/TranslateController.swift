import UIKit

final class TranslateController: UIViewController{
    
    @IBOutlet weak var textToTranslateTextView: UITextView!
    @IBOutlet weak var textTranslatedTextView: UITextView!

    private let translate = TranslateLoader()
    
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
                    
                case .failure(_):
                    self?.presentAlert(message: "Une erreur s'est produite pendant la récupération des données.")
                }
            }
        }
    }
}
