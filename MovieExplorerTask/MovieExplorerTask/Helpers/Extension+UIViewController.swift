//
//  Extension+UIViewController.swift
//  MovieExplorerTask
//
//  Created by Apple on 25/07/25.
//

import Foundation
import UIKit

extension UIViewController {
    func navTitleColor() {
        view.backgroundColor = .systemBackground
        overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.tintColor = .white.withAlphaComponent(0.5)
    }
    
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
    
    func showLoader() {
        let loader = UIActivityIndicatorView(style: .large)
        loader.center = view.center
        loader.color = .gray
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.tag = 99999  // Unique tag to identify the loader
        view.addSubview(loader)
    }
    
    func hideLoader() {
        if let loader = view.viewWithTag(99999) as? UIActivityIndicatorView {
            loader.stopAnimating()
            loader.removeFromSuperview()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension URL: Identifiable {
    public var id: String { absoluteString }
}
