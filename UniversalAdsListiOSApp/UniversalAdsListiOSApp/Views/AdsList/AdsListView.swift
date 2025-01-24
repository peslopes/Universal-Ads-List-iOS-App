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
                    List(viewModel.filteredAds) { ad in
                        AdItemView(ad: ad)
                    }
                    .searchable(text: $viewModel.searchText, prompt: Layout.textFieldPlaceholder)
                }
            }
            .navigationTitle(Layout.navigationTitle)
            .searchable(text: $viewModel.searchText, prompt: Layout.textFieldPlaceholder)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    FilterMenuView(isUrgentOnly: $viewModel.isUrgentOnly, sortOrder: $viewModel.sortOrder)
                }
            }
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
