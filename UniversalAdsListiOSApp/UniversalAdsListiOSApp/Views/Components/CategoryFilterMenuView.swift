import SwiftUI

struct CategoryFilterMenuView: View {
    @StateObject var viewModel: CategoryFilterMenuViewModel
    
    var body: some View {
        Menu {
            Button(action: {
                viewModel.selectAll()
            }) {
                Text(Layout.selectAllText)
            }
            
            Button(action: {
                viewModel.unselectAll()
            }) {
                Text(Layout.unselectAllText)
            }
            
            Divider()
            
            ForEach(viewModel.categories, id: \.self) { category in
                Button(action: {
                    viewModel.toggleCategorySelection(category)
                }) {
                    HStack {
                        Text(category.name)
                        Spacer()
                        if viewModel.selectedCategories.contains(category) {
                            Image(systemName: Layout.categorySelectedSystemImage)
                        } else {
                            Image(systemName: Layout.categoryUnselectedSystemImage)
                        }
                    }
                }
            }
        } label: {
            Image(systemName: Layout.menuLabelSystemImage)
        }
        .onAppear {
            viewModel.fetchCategories()
        }
    }
}

extension CategoryFilterMenuView {
    enum Layout {
        static let selectAllText = "Select All"
        static let unselectAllText = "Unselect All"
        
        static let categorySelectedSystemImage = "checkmark.square"
        static let categoryUnselectedSystemImage = "square"
        
        static let menuLabelSystemImage = "square.grid.2x2"
    }
}

#Preview {
    CategoryFilterMenuView(viewModel: CategoryFilterMenuViewModel(filterHandler: FilterHandler()))
}
