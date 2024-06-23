//
//  TabBarController.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

class TabBarController: UITabBarController {
 
    let searchNavigation = UINavigationController()
    let favoritesNavigation = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchNavigation.tabBarItem = UITabBarItem(title: TabBarStrings.Title.search,
                                                   image: UIImage(named: TabBarStrings.Image.search),
                                                   selectedImage: UIImage(named: TabBarStrings.Image.searchSelected))
        favoritesNavigation.tabBarItem = UITabBarItem(title: TabBarStrings.Title.favorites,
                                                      image: UIImage(named: TabBarStrings.Image.favorites),
                                                      selectedImage: UIImage(named: TabBarStrings.Image.favoritesSelected))
        viewControllers = [searchNavigation, favoritesNavigation]
        tabBar.backgroundColor = .systemGray6
    }
}
