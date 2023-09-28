import UIKit

class TranslateController: UIViewController{
    
    @IBOutlet weak var translationTextField: UITextField!
    @IBOutlet weak var textTranslatedTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    let translate = TranslateLoader()
    let url = TranslationEndpoint.translationUrl("").url(baseURL: URL(string: "https://translation.googleapis.com")!)
    
    @IBAction func translateButton(_ sender: UIButton) {
        translate.load(text: "\(translationTextField.text ?? "")") { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(translation):
                    let translatedDatas = translation.data
                    let gettingTheArrayOfTranslations = translatedDatas.translations
                    
                    for datasTranslated in gettingTheArrayOfTranslations {
                        self.textTranslatedTextView.text = datasTranslated.translatedText
                    }
                case let .failure(APIError):
                    print(APIError, "Je suis une erreur")
                }
            }
        }
    }
}
