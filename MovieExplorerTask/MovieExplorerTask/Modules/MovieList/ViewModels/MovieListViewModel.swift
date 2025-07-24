//
//  MovieListViewModel.swift
//  MovieExplorer
//
//  Created by Apple on 23/07/25.
//

import UIKit

//class MovieListViewModel {
//    var movies: [Movie] = []
//    var onDataFetched: (() -> Void)?
//
//    private let service = ServiceManager()
//
//    func loadMovies() {
//        service.fetchPopularMovies { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let movies):
//                    self?.movies = movies
//                    self?.onDataFetched?()
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}


class MovieListViewModel {
    var movies: [Movie] = []
    var page = 1
    var isLoading = false
    var query: String? = nil

    var onUpdate: (() -> Void)?
    
    func fetchMovies(reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true

        if reset {
            page = 1
            movies.removeAll()
        }

        ServiceManager.shared.fetchPopularMovies(query: query, page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let newMovies):
                self.movies.append(contentsOf: newMovies)
                self.onUpdate?()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func loadNextPageIfNeeded(currentIndex: Int) {
        if currentIndex == movies.count - 1 {
            page += 1
            fetchMovies()
        }
    }

    func updateSearch(query: String) {
        self.query = query
        fetchMovies(reset: true)
    }
}
