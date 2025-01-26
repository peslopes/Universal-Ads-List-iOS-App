import SwiftUI

struct AdItemView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private var imageSize: CGFloat {
        horizontalSizeClass == .compact ? Layout.imageSizeCompact : Layout.imageSizeRegular
    }
    
    let category: String
    let ad: AdModel
    
    var body: some View {
        HStack {
            AdImageView(imageURLString: ad.imagesURL.small)
                .scaledToFit()
                .frame(width: imageSize, height: imageSize)
            
            VStack(alignment: .leading) {
                HStack {
                    if ad.isUrgent {
                        Image(systemName: Layout.urgentIndicatorSystemImageName)
                            .foregroundStyle(Layout.urgentIndicatorForegroundStyle)
                        
                    }
                    Text(ad.title)
                        .font(.headline)
                }
                
                Text(category)
                    .font(.caption)
            }
            .padding(.vertical)
            
            Spacer()
            
            Text("\(ad.price)\(Layout.adPriceCurrencyString)")
        }
    }
}

extension AdItemView {
    enum Layout {
        static let adPriceCurrencyString = "€"
        static let urgentIndicatorSystemImageName = "exclamationmark.triangle.fill"
        static let urgentIndicatorForegroundStyle = Color.red
        static let imageSizeCompact: CGFloat = 50
        static let imageSizeRegular: CGFloat = 100
    }
}

#Preview {
    AdItemView(
        category: "test",
        ad: AdModel(
            id: 0,
            title: "Ad1",
            description: "test description",
            price: 10,
            categoryID: 1,
            imagesURL: ImagesURL(
                small: nil,
                thumb: nil
            ),
            isUrgent: true
        )
    )
}
