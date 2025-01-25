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
                        
                        CategoryFilterMenuView(viewModel: CategoryFilterMenuViewModel(filterHandler: viewModel.filterHandler))
                    }
                    .padding()
                    
                    List(viewModel.filteredAds) { ad in
                        AdItemView(ad: ad)
                    }
                }
            }
            .navigationTitle(Layout.navigationTitle)
            .onAppear() {
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
