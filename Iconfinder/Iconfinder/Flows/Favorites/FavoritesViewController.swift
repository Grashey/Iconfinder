//
//  FavoritesViewController.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var presenter: iFavoritesPresenter?
    
    private lazy var favoritesView = FavoritesView()
    
    override func loadView() {
        view = favoritesView
    }
    
    override func viewDidLoad() {
        title = FavoritesStrings.Title.main
    }
    
}
