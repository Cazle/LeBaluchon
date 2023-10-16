import UIKit

final class TranslateController: UIViewController{
    
    @IBOutlet weak var textToTranslateTextView: UITextView!
    @IBOutlet weak var textTranslatedTextView: UITextView!

    private let translate = TranslateLoader()
    
    @IBAction func translateButton(_ sender: UIButton) {
        translate.load(text: "\(textToTranslateTextView.text ?? "")") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(translation):
                    let translatedDatas = translation.data
                    let gettingTheArrayOfTranslations = translatedDatas.translations
                    self?.textTranslatedTextView.text = gettingTheArrayOfTranslations[0].translatedText
                    
                case .failure(_):
                    self?.presentAlert(message: "Une erreur s'est produite pendant la récupération des données.")
                }
            }
        }
    }
}
