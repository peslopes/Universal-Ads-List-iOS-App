import Combine
import UIKit
@testable import UniversalAdsListiOSApp

class MockImageLoader: ImageLoaderProtocol {
    var shouldFailure = false
    
    func loadImage(from urlString: String?) -> AnyPublisher<UIImage?, any Error> {
        if shouldFailure {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return Just(UIImage())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
