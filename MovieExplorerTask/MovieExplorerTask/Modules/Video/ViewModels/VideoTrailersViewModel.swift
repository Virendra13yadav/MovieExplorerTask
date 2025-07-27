//
//  VideoTrailersViewModel.swift
//  MovieExplorerTask
//
//  Created by Apple on 27/07/25.
//

import UIKit
import AVKit

class VideoTrailersViewModel: ObservableObject {
    @Published var trailers: [Video] = []
    @Published var isLoading = false
    @Published var error: String?
    private let playerManager: VideoPlayerManager
    private let movieID: Int

    init(movieID: Int, playerManager: VideoPlayerManager = VideoPlayerManager()) {
        self.movieID = movieID
        self.playerManager = playerManager
    }
}

//MARK: api calling
extension VideoTrailersViewModel {
    func fetchTrailers(comletion: @escaping (() -> Void)) {
        isLoading = true
        error = ""
        ServiceManager.shared.fetchTrailerURL(id: movieID) { [weak self] trailers in
            self?.isLoading = false
            guard let trailers, !trailers.isEmpty else {
                print("error")
                comletion()
                return
            }
            self?.trailers = trailers
            comletion()
        }
    }
    
}
