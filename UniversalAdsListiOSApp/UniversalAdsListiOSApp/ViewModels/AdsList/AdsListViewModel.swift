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
    
    let filterHandler: FilterHandlerProtocol
    
    init(apiService: APIServiceProtocol = APIService(), filterHandler: FilterHandlerProtocol = FilterHandler()) {
        self.apiService = apiService
        self.filterHandler = filterHandler
        setupBindings()
    }
    
    func fetchAds() {
        isLoading = true
        apiService.fetch(.adsList)
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error in
                self?.errorMessage = error.localizedDescription
                return Just(Array<AdModel>())
            }
            .sink { [weak self] ads in
                self?.ads = ads
                self?.applyFilters([])
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}

extension AdsListViewModel {
    private func setupBindings() {
        Publishers
            .CombineLatest(filterHandler.filterPublisher, $sortOrder)
            .sink { [weak self] filters, sortOrder in
                self?.applyFilters(filters)
                self?.sortAds(by: sortOrder)
            }
            .store(in: &cancellables)
        
        $searchText
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.filterHandler.addFilter(
                    AdFilter(id: Constants.searchTextFilterId) { [weak self] ad in
                        guard let self else { return true }
                        return self.searchText.isEmpty || ad.title.localizedCaseInsensitiveContains(self.searchText)
                    }
                )
            }
            .store(in: &cancellables)
        
        $isUrgentOnly
            .sink { [weak self] isUrgent in
                if isUrgent {
                    self?.filterHandler.addFilter(
                        AdFilter(id: Constants.urgentOnlyFilterId) {
                            $0.isUrgent
                        }
                    )
                } else {
                    self?.filterHandler.removeFilter(withId: Constants.urgentOnlyFilterId)
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func applyFilters(_ filters: Set<AdFilter>) {
        filteredAds = ads.filter { ad in
            filters.isEmpty || filters.allSatisfy( { $0.filter(ad) } )
        }
    }
    
    private func sortAds(by sortOrder: SortOrder) {
        filteredAds.sort { applySortOrder($0, ad2: $1, sortOrder: sortOrder) }
    }
    
    private func addUrgentFilter(_ ad: AdModel, isUrgentOnly: Bool) -> Bool {
        guard isUrgentOnly else { return true }
        return ad.isUrgent
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
    enum Constants {
        static let searchTextFilterId = "searchTextFilter"
        static let urgentOnlyFilterId = "isUrgentFilter"
    }
}
