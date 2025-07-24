//
//  SearchViewModel.swift
//  MovieExplorerTask
//
//  Created by Apple on 25/07/25.
//

import Foundation

final class SearchViewModel {
    var onResultsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?

    private var allResults: [Movie] = []
    private(set) var filteredResults: [Movie] = []

    private var debounceWorkItem: DispatchWorkItem?

    func searchMovie(query: String) {
        // Cancel any pending search
        debounceWorkItem?.cancel()

        // Only search if query length >= 3
        guard query.count >= 3 else {
            self.filteredResults = []
            self.onResultsUpdated?()
            return
        }

        // Debounce for 500ms
        let task = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            ServiceManager.shared.searchMovies(query: query) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movies):
                        // Exact word match filter (case-insensitive)
                        self.filteredResults = movies.filter {
                            $0.title.range(of: query, options: [.caseInsensitive, .regularExpression]) != nil
                        }
                        self.onResultsUpdated?()
                    case .failure(let error):
                        self.onError?(error)
                    }
                }
            }
        }

        debounceWorkItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
    }
}
