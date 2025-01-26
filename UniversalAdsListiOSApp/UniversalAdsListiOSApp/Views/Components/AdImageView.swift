import SwiftUI

struct AdImageView: View {
    let imageURLString: String?
    
    var body: some View {
        if let imageURLString, let url = URL(string: imageURLString) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: Layout.imageCornerRadius))
                case .failure:
                    fallback
                @unknown default:
                    fallback
                }
            }
        } else {
            fallback
        }
    }
    
    private var fallback: some View {
        Image(systemName: Layout.fallbackSystemImageName)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.gray)
    }
}

extension AdImageView {
    enum Layout {
        static let imageCornerRadius: CGFloat = 8
        static let fallbackSystemImageName = "photo"
    }
}

#Preview {
    AdImageView(imageURLString: nil)
}
