import Combine
import UIKit

class AdDetailsViewModel {
    let ad: AdModel
    let category: String
    let imageLoader: ImageLoaderProtocol
    
    @Published var image: UIImage?
    var title: String { ad.title }
    var price: String { "\(ad.price)\(Constants.priceCurrency)" }
    var description: String { ad.description }
    var isUrgent: Bool { ad.isUrgent }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(ad: AdModel, category: String, imageLoader: ImageLoaderProtocol = ImageLoader()) {
        self.ad = ad
        self.category = category
        self.imageLoader = imageLoader
    }
    
    func fetchImage() {
        imageLoader.loadImage(from: ad.imagesURL.thumb)
            .receive(on: DispatchQueue.main)
            .replaceError(with: UIImage(systemName: Constants.replaceErrorImageSystemName))
            .sink { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
    }
}

extension AdDetailsViewModel {
    enum Constants {
        static let replaceErrorImageSystemName = "photo"
        static let priceCurrency = "€"
    }
}
