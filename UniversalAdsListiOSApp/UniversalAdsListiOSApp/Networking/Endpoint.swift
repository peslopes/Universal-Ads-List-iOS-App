import Foundation

enum Endpoint {
    static let baseURL = "https://raw.githubusercontent.com/leboncoin/paperclip/master"
    
    case adsList
    
    var url: URL? {
        switch self {
        case .adsList:
            return URL(string: "\(Self.baseURL)/listing.json")
        }
    }
}
