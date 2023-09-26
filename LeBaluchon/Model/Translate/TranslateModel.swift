import Foundation

struct TranslateModel: Decodable {
    
    struct TranslateDatas: Codable {
        let translation: [Translations]
        struct Translations: Codable {
            let translatedText: String
        }
    }
    let datas: [TranslateDatas]
}
