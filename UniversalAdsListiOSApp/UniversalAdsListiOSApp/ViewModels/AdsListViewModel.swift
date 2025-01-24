import Combine
import Foundation

class AdsListViewModel: ObservableObject {
    private var ads: [AdModel] = []
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    func fetchAds() {
        isLoading = true
        apiService.fetch(.adsList)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    print("Publisher is finished")
                }
            }, receiveValue: { [weak self] ads in
                guard let self else { return }
                self.ads = ads
            })
            .store(in: &cancellables)
    }
}
