//
//  FavoritesViewController.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//

import UIKit
import CoreData
import Photos

class FavoritesViewController: UIViewController {
    
    var presenter: iFavoritesPresenter?
    
    private lazy var favoritesView = FavoritesView()
    
    override func loadView() {
        view = favoritesView
    }
    
    override func viewDidLoad() {
        title = FavoritesStrings.Title.main
        
        favoritesView.configureTableView(cell: IconTableViewCell.self, with: IconTableViewCell.description())
        favoritesView.configureTableView(delegateAndDataSourse: self)
        
        presenter?.getData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: FavoritesStrings.Title.remove, style: .plain, target: self, action: #selector(removeAll))
        switchButton()
    }
    
    func reloadView(showLabel: Bool) {
        favoritesView.reloadTableView()
        favoritesView.showNoResults(showLabel)
    }
    
    @objc private func removeFavorites(_ sender: UIButton) {
        presenter?.removeAt(sender.tag)
    }
    
    @objc private func removeAll() {
        presenter?.removeAll()
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
    
    private func switchButton() {
        guard let isEmpty = presenter?.viewModels.isEmpty else { return }
        navigationItem.rightBarButtonItem?.isEnabled = !isEmpty
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.viewModels.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IconTableViewCell.description(), for: indexPath)
        if let model = presenter?.viewModels[indexPath.row] {
            (cell as? IconTableViewCell)?.configure(model)
            (cell as? IconTableViewCell)?.configureButton(image: UIImage(named: SearchStrings.Image.remove), tag: indexPath.row)
            (cell as? IconTableViewCell)?.configureButton(target: self, action: #selector(removeFavorites(_:)))
        }
        return cell
    }
}

extension FavoritesViewController: UITableViewDelegate {
    
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

extension FavoritesViewController: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        presenter?.getData()
        switchButton()
    }
}
