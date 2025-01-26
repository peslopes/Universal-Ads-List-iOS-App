import Combine
import Foundation

class CategoryFilterMenuViewModel: ObservableObject {
    @Published var categories: [CategoryModel] = []
    @Published var selectedCategories: Set<CategoryModel> = []
    
    private var cancellables = Set<AnyCancellable>()
    private let filterHandler: FilterHandlerProtocol
    private let categoriesPublisher: AnyPublisher<[CategoryModel], Never>
    
    init(categoriesPublisher: AnyPublisher<[CategoryModel], Never>, filterHandler: FilterHandlerProtocol) {
        self.categoriesPublisher = categoriesPublisher
        self.filterHandler = filterHandler
        setupBindings()
    }
    
    func selectAll() {
        selectedCategories = Set(categories)
        updateCategoryFilter()
    }
    
    func unselectAll() {
        selectedCategories = []
        updateCategoryFilter()
    }
    
    func toggleCategorySelection(_ category: CategoryModel) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        updateCategoryFilter()
    }
}

extension CategoryFilterMenuViewModel {
    private func setupBindings() {
        categoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.categories = categories
            }
            .store(in: &cancellables)
    }
    
    private func updateCategoryFilter() {
        filterHandler.addFilter(
            AdFilter(id: Constants.categoryFilterId) { [weak self] ad in
                guard let self else { return true }
                return self.selectedCategories.isEmpty || selectedCategories.contains(where: { $0.id == ad.categoryID })
            }
        )
    }
}

extension CategoryFilterMenuViewModel {
    enum Constants {
        static let categoryFilterId = "categoryFilter"
    }
}
