//
//  MoviewDetailViewModel.swift
//  MovieExplorer
//
//  Created by Apple on 24/07/25.
//

import Foundation
import UIKit

class MovieDetailViewModel {
    //video trailers
    @Published var trailers: [Video] = []
    @Published var isLoading = false
    @Published var error: String?
    //movie details
    let movieID: Int
    var movie: MovieDetail?
    //callback
    var onUpdate: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(movieID: Int) {
        self.movieID = movieID
    }

    //methods
    func toggleFavorite() -> Bool {
        guard let movie = movie else { return false }
        return FavoritesManager.shared.toggleFavorite(movie: movie)
    }

    func isFavorite() -> Bool {
        return FavoritesManager.shared.isFavorite(id: movieID)
    }
}

//MARK: api calling
extension MovieDetailViewModel {
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
}
