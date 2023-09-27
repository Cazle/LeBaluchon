import UIKit

class TranslateController: UIViewController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    let translate = TranslateLoader()
    let url = TranslationEndpoint.translationUrl("Je m'appelle Kyllian").url(baseURL: URL(string: "https://translation.googleapis.com")!)
    
    @IBAction func translateButton(_ sender: UIButton) {
        translate.load(text: "Je m'appelle Kyllian") { result in
            switch result {
            case let .success(Data):
                print(Data)
            case let .failure(APIError):
                print(APIError, "Je suis une erreur")
            }
        }
    }
}
