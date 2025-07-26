//
//  MovieListViewModel.swift
//  MovieExplorer
//
//  Created by Apple on 23/07/25.
//

import UIKit

class MovieListViewModel {
    var filterOptions = FilterOptions()
    var movies: [Movie] = []
    var page = 1
    var isLoading = false
    var query: String? = nil

    var onUpdate: (() -> Void)?
    
    func fetchMovies(reset: Bool = false, params: [String: Any] = [:]) {
        guard !isLoading else { return }
        isLoading = true

        if reset {
            page = 1
            movies.removeAll()
        }
        print("query after reset is \(reset), params is \(params) --> ", query ?? "")
        ServiceManager.shared.fetchPopularMovies(params: params, query: query, page: page) { [weak self] result in
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
        movies.removeAll()
        print(" search query --> ", query)
        
        ServiceManager.shared.searchMovies(query: query) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let newMovies):
                self.movies.append(contentsOf: newMovies)
                self.onUpdate?()
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func applyFilter(sort: String, genre: String?, year: String?) {
        movies.removeAll()
        
        var params: [String: String] = [
            "api_key": APIConstants.apiKey,
            "sort_by": sort,
            "page": "\(page)"
        ]
        
        if let genre = genre {
            params["with_genres"] = genreID(for: genre)
        }
        if let year = year {
            params["primary_release_year"] = year
        }
        
        fetchMovies(reset: true, params: params)
    }

    private func genreID(for name: String) -> String {
        let map: [String: String] = [
            "Action": "28", "Comedy": "35", "Drama": "18", "Horror": "27"
        ]
        return map[name] ?? ""
    }
    
    func resetPagination() {
        page = 1
        movies.removeAll()
    }
}
