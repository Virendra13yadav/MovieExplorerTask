//
//  FilterOptions.swift
//  MovieExplorerTask
//
//  Created by Apple on 26/07/25.
//

import Foundation

struct FilterOptions {
    var sortBy: SortType = .popularity
    var genre: Genre?
    var year: String?

    enum SortType: String {
        case rating = "vote_average.desc"
        case popularity = "popularity.desc"
    }
}

