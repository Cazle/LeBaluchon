import UIKit

class TranslateController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    let translate = TranslateCallAPI()
    let url = TranslationEndpoint.translationUrl.url(baseURL: URL(string: "https://translation.googleapis.com")!, textToTranslate: "Je m'appelle Kyllian")
    
    @IBAction func translateButton(_ sender: UIButton) {
        translate.testAPI(url: url) { result in
            switch result {
            case let .success(Data):
                print(Data)
            case let .failure(APIError):
                print(APIError, "Je suis un erreur")
            }
        }
    }
}
