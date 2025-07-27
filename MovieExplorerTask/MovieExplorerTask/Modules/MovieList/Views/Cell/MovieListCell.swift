//
//  MovieListCell.swift
//  MovieExplorerTask
//
//  Created by Apple on 24/07/25.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {
    static let identifier = "MovieCell"

    private let poster = UIImageView()
    private let titleLabel = UILabel()
    private let releaseLabel = UILabel()
    private let ratingLabel = UILabel()
    private let containerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear

        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor.systemGray6 : UIColor.systemBackground
        }
        containerView.layer.shadowColor = UIColor.label.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.translatesAutoresizingMaskIntoConstraints = false

        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        poster.layer.cornerRadius = 8
        poster.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label

        releaseLabel.font = .systemFont(ofSize: 14)
        releaseLabel.textColor = .secondaryLabel

        ratingLabel.font = .systemFont(ofSize: 14)
        ratingLabel.textColor = .systemYellow

        let infoStack = UIStackView(arrangedSubviews: [titleLabel, releaseLabel, ratingLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView(arrangedSubviews: [poster, infoStack])
        hStack.spacing = 12
        hStack.alignment = .center
        hStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(hStack)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            poster.widthAnchor.constraint(equalToConstant: 90),
            poster.heightAnchor.constraint(equalToConstant: 120),

            hStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            hStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            hStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }

    func configure(with movie: Movie) {
        let date = movie.releaseDate.toFormattedDate()
        let rating = String(format: "%.1f", movie.voteAverage)
        
        titleLabel.text = movie.title
        releaseLabel.text = "Release: \(date)"
        ratingLabel.text = "⭐️ \(rating)"

        if let path = movie.posterPath {
            let url = URL(string: "\(APIConstants.imageBaseURL)\(path)")
            DispatchQueue.global().async { [weak self] in
                if let url = url, let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.poster.image = image
                    }
                } else {
                    self?.setPlaceholderImage()
                }
            }
        } else {
            setPlaceholderImage()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPlaceholderImage() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {return}
            let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .light)
            let placeholder = UIImage(systemName: "photo", withConfiguration: config)?
                .withTintColor(.systemGray, renderingMode: .alwaysOriginal)

            poster.image = placeholder
            poster.contentMode = .center
        }
    }
}
