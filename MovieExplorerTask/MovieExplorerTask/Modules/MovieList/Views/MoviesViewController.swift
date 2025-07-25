//
//  MoviesViewController.swift
//  MovieExplorerTask
//
//  Created by Apple on 24/07/25.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private lazy var noDataLabel = createNoDataLabel(text: "No movies found")
    private let loader = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView()
    private let viewModel = MovieListViewModel()
    private var searchBar = UISearchBar()
    private var searchTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    func initialSetup() {
        overrideUserInterfaceStyle = .dark
        title = "Movies"
        view.backgroundColor = .systemBackground
        setupTableViewWithSearch()
        addNoData()
        showLoader()
        
        viewModel.onUpdate = { [weak self] in
            guard let self else {return}
            self.hideLoader()
            noDataLabel.isHidden = !viewModel.movies.isEmpty
            self.tableView.reloadData()
        }

        viewModel.fetchMovies()
    }

    // MARK: Setup Methods
    private func setupTableViewWithSearch() {
        searchBar.placeholder = "Search Movies"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .label
        searchBar.searchTextField.backgroundColor = .secondarySystemBackground
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.rowHeight = 140
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear

        let stackView = UIStackView(arrangedSubviews: [searchBar, tableView])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

    // MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModel.movies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as! MovieCell
        cell.configure(with: movie)
        viewModel.loadNextPageIfNeeded(currentIndex: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        let detailVC = MovieDetailViewController(movieID: movie.id)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: Search (Debounced)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.viewModel.updateSearch(query: searchText)
        }
    }
}
