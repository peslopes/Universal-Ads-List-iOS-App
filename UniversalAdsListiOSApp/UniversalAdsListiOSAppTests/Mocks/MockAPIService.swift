import Combine
import Foundation
@testable import UniversalAdsListiOSApp

class MockAPIService: APIServiceProtocol {
    var shouldFail = false
    
    func fetch<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error>{
        if shouldFail {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
        
        switch endpoint {
        case .adsList:
            return Just([
                AdModel(
                    id: 0,
                    title: "B",
                    description: "test",
                    price: 15,
                    categoryID: 1,
                    imagesURL: ImagesURL(small: nil, thumb: nil),
                    isUrgent: false
                ),
                AdModel(
                    id: 1,
                    title: "D",
                    description: "test",
                    price: 20,
                    categoryID: 2,
                    imagesURL: ImagesURL(small: nil, thumb: nil),
                    isUrgent: true
                ),
                AdModel(
                    id: 2,
                    title: "A",
                    description: "test",
                    price: 10,
                    categoryID: 3,
                    imagesURL: ImagesURL(small: nil, thumb: nil),
                    isUrgent: false
                ),
                AdModel(
                    id: 3,
                    title: "C",
                    description: "test",
                    price: 25,
                    categoryID: 4,
                    imagesURL: ImagesURL(small: nil, thumb: nil),
                    isUrgent: false
                )
            ] as! T)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        case .categories:
            return Just([
                CategoryModel(id: 1, name: "category1"),
                CategoryModel(id: 2, name: "category2")
            ] as! T)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        }
    }
}
