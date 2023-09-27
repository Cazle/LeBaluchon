import Foundation


struct TranslateModel: Codable {
    let data: DataClass
}
struct DataClass: Codable {
    let translations: [Translation]
}
struct Translation: Codable {
    let translatedText: String
}
