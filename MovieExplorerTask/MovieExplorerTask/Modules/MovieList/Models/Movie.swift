//
//  Movie.swift
//  MovieExplorer
//
//  Created by Apple on 23/07/25.
//

import Foundation

struct PopularMovie: Codable {
    let page: Int
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let popularity: Double
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id
        case popularity
        case title
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
