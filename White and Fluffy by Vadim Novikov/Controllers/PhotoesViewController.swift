//
//  PhotoesViewController.swift
//  White and Fluffy by Vadim Novikov
//
//  Created by Vadim Novikov on 05.06.2022.
//

import UIKit

final class PhotoesViewController: UIViewController {
    
    private let networkDataFetcher: NetworkDataFetcher
    private var timer: Timer?
    private var images = [Image]()
    private var randomImages = [Image]()
    private var searchBarIsEmpty = true
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(PhotoesTableViewCell.self, forCellReuseIdentifier: PhotoesTableViewCell.reuseId)
        return tableView
    }()
    
    init(networkDataFetcher: NetworkDataFetcher) {
        self.networkDataFetcher = networkDataFetcher
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Photoes"
        setConstraints()
        setSearchBar()
        setRandomImages()
    }
    
    private func setRandomImages() {
        self.networkDataFetcher.fetchRandomImages { [weak self] (randomSingleImages) in
            guard let self = self else { return }
            guard let fetchedImages = randomSingleImages else { return }
            DispatchQueue.main.async {
                self.randomImages = fetchedImages
                self.images = fetchedImages
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - setConstraints

extension PhotoesViewController {
    
    private func setConstraints () {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension PhotoesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoesTableViewCell.reuseId, for: indexPath) as? PhotoesTableViewCell else { return .init() }
        let singleImage = images[indexPath.row]
        cell.singleImage = singleImage as? SingleImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let image = images[indexPath.row] as? SingleImage else { return }
        let id = image.id
        let infoVC = DetailInfoViewController()
        infoVC.networkDataFetcher = networkDataFetcher
        infoVC.id = id
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
}

// MARK: - UITableViewDataSourcePrefetching

extension PhotoesViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if searchBarIsEmpty {
            for index in indexPaths {
                if index.row == images.count - 1 {
                    self.networkDataFetcher.fetchRandomImages { [weak self] (randomSingleImages) in
                        guard let self = self else { return }
                        guard let fetchedImages = randomSingleImages else { return }
                        DispatchQueue.main.async {
                            self.randomImages += fetchedImages
                            self.images = self.randomImages
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}

// MARK: - UISeachBarDelegate

extension PhotoesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            if searchText.count == 0 || searchText == " " {
                DispatchQueue.main.async {
                    self.searchBarIsEmpty = true
                    self.images = self.randomImages
                    self.tableView.reloadData()
                }
            } else {
                self.networkDataFetcher.fetchSearchImages(searchText: searchText) { [weak self] (searchResults) in
                    guard let self = self else { return }
                    guard let fetchedImages = searchResults else { return }
                    DispatchQueue.main.async {
                        self.searchBarIsEmpty = false
                        self.images = fetchedImages.results
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBarIsEmpty = true
        images = randomImages
        self.tableView.reloadData()
    }
    
}
