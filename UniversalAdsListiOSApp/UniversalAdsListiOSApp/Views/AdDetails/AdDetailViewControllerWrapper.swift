import SwiftUI

struct AdDetailsViewControllerWrapper: UIViewControllerRepresentable {
    let ad: AdModel
    let category: String
    
    func makeUIViewController(context: Context) -> AdDetailsViewController {
        return AdDetailsViewController(viewModel: AdDetailsViewModel(ad: ad, category: category))
    }
    
    func updateUIViewController(_ uiViewController: AdDetailsViewController, context: Context) { }
}
