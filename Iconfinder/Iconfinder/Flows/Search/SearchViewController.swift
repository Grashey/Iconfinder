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
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        searchView.configureTableView(cell: IconTableViewCell.self, with: IconTableViewCell.description())
        searchView.configureTableView(delegateAndDataSourse: self)
        
        presenter?.getData()
    }
    
    func reloadView() {
        searchView.reloadTableView()
    }
    
    func reloadRowAt(index: Int) {
        searchView.reloadRows(at: [IndexPath(row: index, section: .zero)])
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
    
}
