import UIKit
import Combine

protocol ImageLoaderProtocol {
    func loadImage(from urlString: String?) -> AnyPublisher<UIImage?, Error>
}
