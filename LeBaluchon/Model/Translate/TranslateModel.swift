import Foundation

struct TranslateModel: Decodable {
    
    struct data: Codable {
        struct translations: Codable {
            let translatedText: String
        }
    }
    let datas: [data]
}
