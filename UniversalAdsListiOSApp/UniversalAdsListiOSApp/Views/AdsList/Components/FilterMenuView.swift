import SwiftUI

struct FilterMenuView: View {
    @Binding var isUrgentOnly: Bool
    @Binding var sortOrder: AdsListViewModel.SortOrder
    
    var body: some View {
        Menu {
            Button(action: {
                isUrgentOnly.toggle()
            }) {
                Label(
                    Layout.urgentOnlyLabel,
                    systemImage: isUrgentOnly ? Layout.filterOnSystemImage : Layout.filterOffSystemImage
                )
            }
            
            Divider()
            
            ForEach(Layout.sortOptions, id: \.self) { option in
                Button(action: {
                    sortOrder = option.sortOrder
                }) {
                    HStack {
                        Text(option.title)
                        Spacer()
                        if sortOrder == option.sortOrder {
                            Image(systemName: Layout.sortOnSystemImage)
                        }
                    }
                }
            }
        } label: {
            Label(Layout.filterMenuLabel, systemImage: Layout.filterMenuSystemImage)
        }
    }
}

extension FilterMenuView {
    enum Layout {
        static let filterOnSystemImage = "checkmark.square"
        static let filterOffSystemImage = "square"
        static let sortOnSystemImage = "checkmark"
        static let urgentOnlyLabel = "Uergent only"
        
        static let filterMenuLabel = "Filters"
        static let filterMenuSystemImage = "line.horizontal.3.decrease.circle"
        
        static let sortOptions: [SortOption] = [
            SortOption(title: "Alphabetical (A-Z)", sortOrder: .alphabeticalAscending),
            SortOption(title: "Alphabetical (Z-A)", sortOrder: .alphabeticalDescending),
            SortOption(title: "Price (Low to High)", sortOrder: .priceAscending),
            SortOption(title: "Price (High to Low)", sortOrder: .priceDescending),
            SortOption(title: "Default Order", sortOrder: .none)
        ]
        
        struct SortOption: Hashable {
            let title: String
            let sortOrder: AdsListViewModel.SortOrder
        }
    }
}

#Preview {
    FilterMenuView(isUrgentOnly: .constant(false), sortOrder: .constant(.none))
}
