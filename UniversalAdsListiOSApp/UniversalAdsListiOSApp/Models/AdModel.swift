import Foundation

struct AdModel: Identifiable, Decodable {
    let id: Int
    let title: String
    let price: Int
    let categoryID: Int
    let imagesURL: ImagesURL
    let isUrgent: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, price
        case categoryID = "category_id"
        case imagesURL = "images_url"
        case isUrgent = "is_urgent"
    }
}

struct ImagesURL: Decodable {
    let small: String?
    let thumb: String?
}
