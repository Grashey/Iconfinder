//
//  SearchViewController.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    var presenter: iSearchPresenter?
    
    private lazy var searchView = SearchView()
    
    private lazy var searchController: UISearchController = {
        $0.searchBar.searchBarStyle = .prominent
        $0.searchBar.placeholder = SearchStrings.Title.searchPlaceholder
        $0.searchBar.sizeToFit()
        $0.obscuresBackgroundDuringPresentation = false
        return $0
    }(UISearchController())
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        title = SearchStrings.Title.main
        
        searchController.searchBar.placeholder = SearchStrings.Title.searchPlaceholder
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        searchView.configureTableView(cell: IconTableViewCell.self, with: IconTableViewCell.description())
        searchView.configureTableView(delegateAndDataSourse: self)
        
        presenter?.findIcons(with: "")
    }
    
    func reloadView() {
        searchView.reloadTableView()
    }
    
    func reloadRowAt(index: Int) {
        searchView.reloadRows(at: [IndexPath(row: index, section: .zero)])
    }
    
    private func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.viewModels.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IconTableViewCell.description(), for: indexPath)
        let image = UIImage(named: SearchStrings.Image.add)
        if let model = presenter?.viewModels[indexPath.row] {
            (cell as? IconTableViewCell)?.configure(model)
            (cell as? IconTableViewCell)?.configureButton(image: image)
        }
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("icon save")
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            presenter?.clearSearch()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.clearSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let text = searchBar.searchTextField.text else { return }
        presenter?.findIcons(with: text)
    }
}

extension SearchViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}
