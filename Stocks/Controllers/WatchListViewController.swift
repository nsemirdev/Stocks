//
//  WatchListViewController.swift
//  Stocks
//
//  Created by Emir Alkal on 17.01.2023.
//

import UIKit
import FloatingPanel

final class WatchListViewController: UIViewController {

    private var searchTimer: Timer?
    private var panel: FloatingPanelController?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        return tableView
    }()
    
    private var viewModels: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSearchController()
        setUpTableView()
        fetchWatchListData()
        setUpTitleView()
        setUpFloatingPanel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private var watchListMap = [String: [CandleStick]]()
    
    private func fetchWatchListData() {
        let group = DispatchGroup()
        for symbol in PersistenceManager.shared.watchlist {
            group.enter()
            APICaller.shared.markedData(for: symbol) { [weak self] result in
                defer { group.leave() }
                
                switch result {
                case .success(let data):
                    let candleSticks = data.candleSticks
                    self?.watchListMap[symbol] = candleSticks
                case .failure(let failure):
                    print(failure)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func setUpTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpFloatingPanel() {
        let vc = NewsViewController(type: .topStories)
        
        panel = FloatingPanelController()
        panel?.surfaceView.backgroundColor = .secondarySystemBackground
        panel?.set(contentViewController: vc)
        panel?.addPanel(toParent: self)
        panel?.delegate = self
        panel?.track(scrollView: vc.tableView)
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
        
        searchTimer?.invalidate()
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { t in
            APICaller.shared.search(query: query) { result in
                switch result {
                case .success(let responseModel):
                    DispatchQueue.main.async {
                        resultsVC.update(with: responseModel.result)
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        })
    }
}

extension WatchListViewController: SearchResultsViewControllerDelegate {
    
    func searchResultsViewControllerDelegateDidSelect(searchResult: Stock) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
        
        let detailVC = StockDetailsViewController()
        let navVC = UINavigationController(rootViewController: detailVC)
        detailVC.title = searchResult.description
        present(navVC, animated: true)
    }
    
}

extension WatchListViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        navigationItem.titleView?.isHidden = fpc.state == .full
    }
}

extension WatchListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        PersistenceManager.shared.watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = PersistenceManager.shared.watchlist[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
