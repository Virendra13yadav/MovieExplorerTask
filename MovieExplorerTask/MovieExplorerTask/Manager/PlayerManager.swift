//
//  PlayerManager.swift
//  MovieExplorerTask
//
//  Created by Apple on 25/07/25.
//

import Foundation
import AVKit
import UIKit

final class VideoPlayerManager {
    
    private var player: AVPlayer?
    
    /// Plays video in full screen and forces landscape orientation.
    func playVideo(from url: URL, on viewController: UIViewController) {
        let player = AVPlayer(url: url)
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        playerVC.modalPresentationStyle = .fullScreen

        // Force landscape orientation
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()

        viewController.present(playerVC, animated: true) {
            player.play()
        }

        self.player = player
    }
}
