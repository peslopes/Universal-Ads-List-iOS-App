import SwiftUI

struct AdsListView: View {
    @StateObject private var viewModel = AdsListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(Color.red)
                        .padding()
                }
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    HStack {
                        TextField(Layout.textFieldPlaceholder, text: $viewModel.searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        FilterMenuView(isUrgentOnly: $viewModel.isUrgentOnly, sortOrder: $viewModel.sortOrder)
                        
                        CategoryFilterMenuView(
                            viewModel: CategoryFilterMenuViewModel(
                                categoriesPublisher: viewModel.$categories.eraseToAnyPublisher(),
                                filterHandler: viewModel.filterHandler
                            )
                        )
                    }
                    .padding()
                    
                    List(viewModel.filteredAds) { ad in
                        NavigationLink(destination: AdDetailsViewControllerWrapper(ad: ad, category: viewModel.categoryDictionary[ad.categoryID] ?? "")) {
                            AdItemView(category: viewModel.categoryDictionary[ad.categoryID] ?? "", ad: ad)
                        }
                    }
                }
            }
            .navigationTitle(Layout.navigationTitle)
            .onAppear() {
                viewModel.fetchCategories()
                viewModel.fetchAds()
            }
        }
    }
}

extension AdsListView {
    enum Layout {
        static let navigationTitle = "Ads List"
        static let textFieldPlaceholder = "Search ads..."
    }
}

#Preview {
    AdsListView()
}
