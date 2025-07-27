//
//  VideoTrailerView.swift
//  MovieExplorerTask
//
//  Created by Apple on 27/07/25.
//

import UIKit
import AVKit
import SafariServices

class VideoTrailersViewController: UIViewController {
    private lazy var noDataLabel = createNoDataLabel(text: "Trailers not available")
    private let viewModel: VideoTrailersViewModel
    private let movieTitle: String?
    
    private let titleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: 22)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let tableView: UITableView = {
            let tv = UITableView()
            tv.translatesAutoresizingMaskIntoConstraints = false
            tv.backgroundColor = .black
            tv.separatorStyle = .none
            return tv
        }()
    
    init(viewModel: VideoTrailersViewModel, movieTitle: String) {
        self.viewModel = viewModel
        self.movieTitle = movieTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
}

// MARK: - setup methods
extension VideoTrailersViewController {
    private func initialSetup() {
        navTitleColor()
        showTitle()
        addNoData()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrailerCell.self, forCellReuseIdentifier: "TrailerCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addNoData() {
        view.addSubview(noDataLabel)
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        noDataLabel.isHidden = true
    }
}

// MARK: - api calling
extension VideoTrailersViewController {
    private func fetchData() {
        showLoader()
        viewModel.fetchTrailers { [weak self] in
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.tableView.reloadData()
                self?.noDataLabel.isHidden = !(self?.viewModel.trailers.isEmpty ?? true)
            }
        }
    }
    
    private func showTitle() {
        titleLabel.text = movieTitle ?? "Trailers"
//        let back = UIBarButtonItem()
//        back.title = ""
//        navigationItem.backBarButtonItem = back
//        navigationItem.title = ""
//        navigationController?.navigationBar.backItem?.title = ""
//        navigationController?.navigationItem.backBarButtonItem = back
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension VideoTrailersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.trailers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrailerCell", for: indexPath) as? TrailerCell else {
            return UITableViewCell()
        }
        let trailer = viewModel.trailers[indexPath.row]
        cell.configure(with: trailer)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trailer = viewModel.trailers[indexPath.row]
        playTrailer(with: trailer.key)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Play Trailer
extension VideoTrailersViewController {
    private func playTrailer(with key: String) {
        let str = APIConstants.watchURL + "?v=\(key)"
        guard let url = URL(string: str) else { return }
        print("play url \(url)")
        let safariVC = SFSafariViewController(url: url)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let root = windowScene.windows.first?.rootViewController {
                root.present(safariVC, animated: true, completion: nil)
            }
    }
}
