import UIKit
import Combine

class ImageLoader: ImageLoaderProtocol {
    func loadImage(from urlString: String?) -> AnyPublisher<UIImage?, Error> {
        guard let urlString, let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return Future<UIImage?, Error> { promise in
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: url)
                    promise(.success(UIImage(data: data)))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
