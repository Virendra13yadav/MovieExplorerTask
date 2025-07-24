//
//  MovieDetailViewController.swift
//  MovieExplorer
//
//  Created by Apple on 24/07/25.
//

import UIKit
import AVKit
import RealmSwift
import UserNotifications

class MovieDetailViewController: UIViewController {

    private let movieID: Int
    private var movie: MovieDetail?
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseLabel = UILabel()
    private let ratingLabel = UILabel()
    private let genresLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    init(movieID: Int) {
        self.movieID = movieID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        fetchMovieDetails()
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.axis = .vertical
        contentView.spacing = 12
        contentView.translatesAutoresizingMaskIntoConstraints = false

        [posterImageView, titleLabel, genresLabel, releaseLabel, ratingLabel, overviewLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addArrangedSubview($0)
        }

        favoriteButton.setTitle("❤️ Favorite", for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),

            posterImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func fetchMovieDetails() {
        MovieAPI.shared.fetchMovieDetail(id: movieID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.movie = detail
                    self?.updateUI(with: detail)
                case .failure(let error):
                    print("Error:", error)
                }
            }
        }
    }

    private func updateUI(with movie: MovieDetail) {
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

    @objc private func toggleFavorite() {
        guard let movie = movie else { return }
        let isNowFavorite = FavoritesManager.shared.toggleFavorite(movie: movie)
        updateFavoriteButton()

        if isNowFavorite {
            NotificationManager.shared.sendFavoriteNotification(for: movie.title)
        }
    }

    private func updateFavoriteButton() {
        let isFav = FavoritesManager.shared.isFavorite(id: movieID)
        favoriteButton.setTitle(isFav ? "💔 Unfavorite" : "❤️ Favorite", for: .normal)
    }
}
