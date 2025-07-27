//
//  VideoModel.swift
//  MovieExplorerTask
//
//  Created by Apple on 24/07/25.
//

import Foundation

struct VideoResponse: Decodable {
    let results: [Video]
}

struct Video: Decodable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let published_at: String
    
    var youtubeURL: URL? {
        URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
    var streamURL: URL? {
        // Optional: replace with backend-generated playable HLS URL if needed
        URL(string: "https://www.youtube.com/embed/\(key)")
    }
}
