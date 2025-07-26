//
//  ApiConstants.swift
//  MovieExplorerTask
//
//  Created by Apple on 24/07/25.
//

import Foundation

struct APIConstants {
    static let accecToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxYjc4YTBlODA1MzgxMDIxNzIzOTg0NWI1OWNiNGUxNSIsIm5iZiI6MTc1MzI4MjMwMS41OTYsInN1YiI6IjY4ODBmNmZkMzhiZDkxMDc5MTU1ZGJjZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ._QyiQ4tVBPtFFp-3MDMxZ37gv6SLvOt_05rNwwCfQI0"
    static let apiKey = "1b78a0e8053810217239845b59cb4e15"
    static let baseURL = "https://api.themoviedb.org/3"
    static let popularMovie = baseURL + "/movie/popular"
    static let search = baseURL + "/search/movie"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    static let discoverMovie = baseURL + "/discover/movie"
}
