import Combine

protocol FilterHandlerProtocol {
    var filterPublisher: AnyPublisher<Set<AdFilter>, Never> { get }
    
    func addFilter(_ filter: AdFilter)
    func removeFilter(withId id: String)
    func clearAllFilters()
}
