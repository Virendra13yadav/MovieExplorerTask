//
//  Extension+UIViewController.swift
//  MovieExplorerTask
//
//  Created by Apple on 25/07/25.
//

import Foundation
import UIKit

extension UIViewController {
    func createNoDataLabel(text: String = "No data available") -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
