//
//  WatchListViewController.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import UIKit

final class WatchListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSearchController()
        setUpTitleView()
    }
    
    private func setUpTitleView() {
        let titleView = UIView(frame: .init(x: 0, y: 0, width: view.width, height: navigationController?.navigationBar.height ?? 100))
        
        let label = UILabel(frame: .init(x: 10, y: 0, width: titleView.width - 20, height: titleView.height))
        label.text = "Stocks"
        label.font = .systemFont(ofSize: 36, weight: .medium )
        titleView.addSubview(label)
        navigationItem.titleView = titleView
    }
    
    private func setUpSearchController() {
        let resultVC = SearchResultsViewController()
        resultVC.delegate = self
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = self
        navigationItem.searchController = searchVC
    }
    
}

extension WatchListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
                  !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        resultsVC.update(with: ["Google"])
        
    }
    
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
    
    func searchResultsViewControllerDelegateDidSelect(searchResult: String) {
        
    }
    
}
