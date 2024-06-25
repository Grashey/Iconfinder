//
//  SearchViewController.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit
import Photos

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
    
    func reloadView(showLabel: Bool) {
        searchView.reloadTableView()
        searchView.showNoResults(showLabel)
    }
    
    func reloadRowAt(index: Int) {
        searchView.reloadRows(at: [IndexPath(row: index, section: .zero)])
    }
    
    private func dismissKeyboard() {
        searchController.searchBar.endEditing(true)
    }
    
    func presentSavedImageAlert() {
        DispatchQueue.main.async { [unowned self] in
            let alert = UIAlertController()
            alert.title = SearchStrings.Alert.request
            alert.addAction(UIAlertAction(title: SearchStrings.Alert.settings, style: .default, handler: { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: SearchStrings.Alert.cancel, style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
        }
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
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            presenter?.saveImageAt(indexPath.row)
        } else {
            PHPhotoLibrary.requestAuthorization { [unowned self] status in
                switch status {
                case .authorized, .limited: presenter?.saveImageAt(indexPath.row)
                case .denied, .restricted: presentSavedImageAlert()
                default: break
                }
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
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