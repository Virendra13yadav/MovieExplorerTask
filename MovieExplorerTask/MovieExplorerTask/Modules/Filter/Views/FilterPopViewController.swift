import UIKit

protocol FilterViewDelegate: AnyObject {
    func didApplyFilter(sortBy: String, genre: String?, year: String?)
}

class FilterView: UIView {

    weak var delegate: FilterViewDelegate?

    private let blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        return UIVisualEffectView(effect: blur)
    }()

    private let containerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()

    private let sortSegmented: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Popularity", "Rating"])
        control.selectedSegmentIndex = 0
        return control
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identifier)
        return collection
    }()

    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 12
        return button
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("✕", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    private let genres = ["All", "Action", "Comedy", "Drama", "Fantasy", "Horror", "Sci-Fi", "Thriller"]
    private let years = (1980...2025).reversed().map { "\($0)" }

    private var selectedGenreIndex: Int = 0
    private var selectedYearIndex: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(blurEffectView)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        containerView.backgroundColor = .black
        containerView.layer.cornerRadius = 24
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)

        [titleLabel, closeButton, sortSegmented, collectionView, applyButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }

        applyButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),

            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            sortSegmented.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            sortSegmented.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            sortSegmented.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            collectionView.topAnchor.constraint(equalTo: sortSegmented.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -16),

            applyButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            applyButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: 200),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func applyFilter() {
        let sort = sortSegmented.selectedSegmentIndex == 0 ? "popularity.desc" : "vote_average.desc"
        let selectedGenre = genres[selectedGenreIndex] == "All" ? nil : genres[selectedGenreIndex]
        let selectedYear = years[selectedYearIndex]
        delegate?.didApplyFilter(sortBy: sort, genre: selectedGenre, year: selectedYear)
        dismiss()
    }

    @objc private func dismiss() {
        self.removeFromSuperview()
    }
}

// MARK: - Compositional Layout
private extension FilterView {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .absolute(36))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(36))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(12)

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
            section.interGroupSpacing = 12

            return section
        }
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension FilterView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // 0 = Genres, 1 = Years
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? genres.count : years.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }

        let text = indexPath.section == 0 ? genres[indexPath.item] : years[indexPath.item]
        let isSelected = (indexPath.section == 0 && indexPath.item == selectedGenreIndex) ||
                         (indexPath.section == 1 && indexPath.item == selectedYearIndex)

        cell.configure(with: text, selected: isSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedGenreIndex = indexPath.item
        } else {
            selectedYearIndex = indexPath.item
        }
        collectionView.reloadSections(IndexSet(integer: indexPath.section))
    }
}
