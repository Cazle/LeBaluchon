import Foundation


struct TranslateModel: Decodable {
    let data: DataClass
}
struct DataClass: Decodable {
    let translations: [Translation]
}
struct Translation: Decodable {
    let translatedText: String
}
