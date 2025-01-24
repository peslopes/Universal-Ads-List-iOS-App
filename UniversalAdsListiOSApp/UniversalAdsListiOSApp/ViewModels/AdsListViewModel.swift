import Combine
import Foundation

class AdsListViewModel: ObservableObject {
    @Published private(set) var filteredAds: [AdModel] = []
    
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    @Published var searchText: String = ""
    @Published var isUrgentOnly = false
    @Published var sortOrder: SortOrder = .none

    private var ads: [AdModel] = []
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        setupBindings()
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
                self.applyFilters(searchText: self.searchText, isUrgentOnly: self.isUrgentOnly, sortOrder: self.sortOrder)
            })
            .store(in: &cancellables)
    }
    
}

extension AdsListViewModel {
    private func setupBindings() {
        Publishers
            .CombineLatest3($searchText, $isUrgentOnly, $sortOrder)
            .sink { [weak self] searchText, isUrgentOnly, sortOrder in
                self?.applyFilters(searchText: searchText, isUrgentOnly: isUrgentOnly, sortOrder: sortOrder)
            }
            .store(in: &cancellables)
    }
    
    private func applyFilters(searchText: String, isUrgentOnly: Bool, sortOrder: SortOrder) {
        filteredAds = ads
            .filter { applyUrgentFilter($0, isUrgentOnly: isUrgentOnly) }
            .filter { applySearchFilter($0, searchText: searchText) }
            .sorted { applySortOrder($0, ad2: $1, sortOrder: sortOrder) }
    }
    
    private func applyUrgentFilter(_ ad: AdModel, isUrgentOnly: Bool) -> Bool {
        guard isUrgentOnly else { return true }
        return ad.isUrgent
    }
    
    private func applySearchFilter(_ ad: AdModel, searchText: String) -> Bool {
        guard !searchText.isEmpty else { return true }
        return ad.title.localizedCaseInsensitiveContains(searchText)
    }
    
    private func applySortOrder(_ ad1: AdModel, ad2: AdModel, sortOrder: SortOrder) -> Bool {
        switch sortOrder {
        case .alphabeticalAscending:
            return ad1.title < ad2.title
        case .alphabeticalDescending:
            return ad1.title > ad2.title
        case .priceAscending:
            return ad1.price < ad2.price
        case .priceDescending:
            return ad1.price > ad2.price
        case .none:
            return false
        }
    }
}

extension AdsListViewModel {
    enum SortOrder {
        case none
        case alphabeticalAscending
        case alphabeticalDescending
        case priceAscending
        case priceDescending
    }
}
