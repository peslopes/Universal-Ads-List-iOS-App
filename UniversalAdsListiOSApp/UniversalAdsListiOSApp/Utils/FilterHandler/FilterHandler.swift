import Combine

class FilterHandler: FilterHandlerProtocol {
    private var filters: Set<AdFilter> = []
    private var filterSubject = PassthroughSubject<Set<AdFilter>, Never>()
    
    var filterPublisher: AnyPublisher<Set<AdFilter>, Never> {
        filterSubject.eraseToAnyPublisher()
    }
    
    func addFilter(_ filter: AdFilter) {
        filters.insert(filter)
        filterSubject.send(filters)
    }
    
    func removeFilter(withId id: String) {
        if let filterToRemove = filters.first(where: { $0.id == id }) {
            filters.remove(filterToRemove)
            filterSubject.send(filters)
        }
    }
    
    func clearAllFilters() {
        filters.removeAll()
        filterSubject.send(filters)
    }
}
