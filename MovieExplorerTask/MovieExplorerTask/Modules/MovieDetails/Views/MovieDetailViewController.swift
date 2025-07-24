//
//  MovieDetailViewController.swift
//  MovieExplorer
//
//  Created by Apple on 24/07/25.
//

import UIKit
import AVKit

class MovieDetailViewController: UIViewController {

    private let viewModel: MovieDetailViewModel

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let genresLabel = UILabel()
    private let releaseLabel = UILabel()
    private let ratingLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    init(movieID: Int) {
        self.viewModel = MovieDetailViewModel(movieID: movieID)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: setup methods
    private func initialSetup() {
        view.backgroundColor = .systemBackground
        overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.tintColor = .white.withAlphaComponent(0.5)
        setupLayout()
        bindViewModel()
        viewModel.fetchDetails()
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        [posterImageView, titleLabel, genresLabel, releaseLabel, ratingLabel, overviewLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentStack.addArrangedSubview($0)
        }

        posterImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10

        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .label

        genresLabel.font = .systemFont(ofSize: 16)
        genresLabel.textColor = .secondaryLabel

        releaseLabel.font = .systemFont(ofSize: 16)
        ratingLabel.font = .systemFont(ofSize: 16)
        ratingLabel.textColor = .systemYellow

        overviewLabel.numberOfLines = 0
        overviewLabel.font = .systemFont(ofSize: 16)

        favoriteButton.setTitleColor(.white.withAlphaComponent(0.5), for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        updateFavoriteButton()
        scrollView.backgroundColor = .clear
        contentStack.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        watchTrailerButton.addTarget(self, action: #selector(watchTrailerTapped), for: .touchUpInside)
        view.addSubview(watchTrailerButton)

        NSLayoutConstraint.activate([
            watchTrailerButton.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 16),
            watchTrailerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            watchTrailerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            watchTrailerButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    private let watchTrailerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🎬 Watch Trailer", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.5)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func watchTrailerTapped() {
        viewModel.playTrailer(on: self)
    }


    //MARK: view Model
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.updateUI()
        }

        viewModel.onError = { error in
            print("Error fetching detail:", error)
        }
    }

    //MARK: UI update
    private func updateUI() {
        guard let movie = viewModel.movie else { return }

        titleLabel.text = movie.title
        releaseLabel.text = "📅 \(movie.releaseDate)"
        ratingLabel.text = "⭐️ \(movie.voteAverage)"
        overviewLabel.text = movie.overview
        genresLabel.text = "Genres: " + movie.genres.map { $0.name }.joined(separator: ", ")

        if let path = movie.posterPath {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = image
                    }
                }
            }
        }

        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        let isFav = viewModel.isFavorite()
        favoriteButton.setTitle(isFav ? "💔 Remove from Favorites" : "❤️ Add to Favorites", for: .normal)
    }

    @objc private func favoriteTapped() {
        let isNowFav = viewModel.toggleFavorite()
        updateFavoriteButton()

        if isNowFav {
            NotificationManager.shared.sendFavoriteNotification(for: viewModel.movie?.title ?? "Movie")
        }
    }
}
