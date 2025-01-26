import Combine
import UIKit

final class AdDetailsViewController: UIViewController {
    private let viewModel: AdDetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Layout.infoStackViewSpacing
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Layout.headerStackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Layout.contentStackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Layout.imageViewCornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Layout.titleLabelFont
        label.numberOfLines = Layout.titleLabelNumberOfLines
        label.textAlignment = Layout.titleLabelAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Layout.priceLabelFont
        label.textColor = Layout.priceLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = Layout.categoryLabelFont
        label.textColor = Layout.categoryLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let urgentLabel: UILabel = {
        let label = UILabel()
        label.font = Layout.urgentLabelFont
        label.textColor = Layout.urgentLabelColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Layout.urgentLabelText
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Layout.descriptionLabelFont
        label.numberOfLines = Layout.descriptionLabelNumberOfLines
        label.textAlignment = Layout.descriptionLabelAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: AdDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        bindViewModel()
        viewModel.fetchImage()
    }
    
    private func setupUI() {
        infoStackView.addArrangedSubview(urgentLabel)
        infoStackView.addArrangedSubview(priceLabel)
        infoStackView.addArrangedSubview(titleLabel)
        infoStackView.addArrangedSubview(categoryLabel)
        
        headerStackView.addArrangedSubview(imageView)
        headerStackView.addArrangedSubview(infoStackView)
        
        contentStackView.addArrangedSubview(headerStackView)
        contentStackView.addArrangedSubview(descriptionLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.contentStackViewPadding),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.contentStackViewPadding),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.contentStackViewPadding),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.contentStackViewPadding),
            
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: Layout.imageSizeMultiplier),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Layout.imageSizeMultiplier)
        ])
    }
    
    private func bindViewModel() {
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        categoryLabel.text = viewModel.category
        descriptionLabel.text = viewModel.description
        urgentLabel.isHidden = !viewModel.isUrgent
        
        viewModel.$image
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.imageView.image = image
            }
            .store(in: &cancellables)
    }
}

extension AdDetailsViewController {
    enum Layout {
        static let infoStackViewSpacing: CGFloat = 8
        static let headerStackViewSpacing: CGFloat = 16
        static let contentStackView: CGFloat = 16
        
        static let imageViewCornerRadius: CGFloat = 8
        
        static let titleLabelFont = UIFont.preferredFont(forTextStyle: .callout)
        static let titleLabelNumberOfLines = 0
        static let titleLabelAlignment: NSTextAlignment = .justified
        
        static let priceLabelFont = UIFont.preferredFont(forTextStyle: .title1)
        static let priceLabelColor: UIColor = .systemGreen
        
        static let categoryLabelFont = UIFont.preferredFont(forTextStyle: .callout)
        static let categoryLabelColor: UIColor = .secondaryLabel
        
        static let urgentLabelFont = UIFont.preferredFont(forTextStyle: .headline)
        static let urgentLabelColor: UIColor = .systemRed
        static let urgentLabelText = "URGENT"
        
        static let descriptionLabelFont = UIFont.preferredFont(forTextStyle: .body)
        static let descriptionLabelNumberOfLines = 0
        static let descriptionLabelAlignment: NSTextAlignment = .justified
        
        static let contentStackViewPadding: CGFloat = 16
        static let imageSizeMultiplier: CGFloat = 0.3
    }
}
