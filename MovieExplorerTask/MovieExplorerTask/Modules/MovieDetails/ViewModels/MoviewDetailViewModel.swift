//
//  MoviewDetailViewModel.swift
//  MovieExplorer
//
//  Created by Apple on 24/07/25.
//

import Foundation
import UIKit

class MovieDetailViewModel {
    let movieID: Int
    var movie: MovieDetail?
    private let playerManager: VideoPlayerManager
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(movieID: Int, playerManager: VideoPlayerManager = VideoPlayerManager()) {
        self.movieID = movieID
        self.playerManager = playerManager
    }

    func fetchDetails() {
        ServiceManager.shared.fetchMovieDetail(id: movieID) { [weak self] detail in
            DispatchQueue.main.async {
                if let detail = detail {
                    self?.movie = detail
                    self?.onUpdate?()
                } else {
                    self?.onError?(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load movie details."]))
                }
            }
        }
    }

    func toggleFavorite() -> Bool {
        guard let movie = movie else { return false }
        return FavoritesManager.shared.toggleFavorite(movie: movie)
    }

    func isFavorite() -> Bool {
        return FavoritesManager.shared.isFavorite(id: movieID)
    }
    
    func playTrailer(on viewController: UIViewController) {
        fetchTrailer { [weak self] url in
            guard let url = url else { return }
            DispatchQueue.main.async {
                self?.playerManager.playVideo(from: url, on: viewController)
            }
        }
    }
    
    func fetchTrailer(completion: @escaping (URL?) -> Void) {
        ServiceManager.shared.fetchMovieTrailer(movieID: movieID) { key in
            guard let key = key else {
                completion(nil)
                return
            }
            // Simulated playable trailer URL
            let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
            completion(url)
        }
    }
}
