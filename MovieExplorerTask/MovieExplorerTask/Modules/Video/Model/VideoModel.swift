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

struct Video: Decodable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}
