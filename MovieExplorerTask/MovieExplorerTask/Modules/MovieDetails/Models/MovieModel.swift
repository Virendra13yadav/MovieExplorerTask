//
//  MovieModel.swift
//  MovieExplorer
//
//  Created by Apple on 24/07/25.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let voteAverage: Double
    let posterPath: String?
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
