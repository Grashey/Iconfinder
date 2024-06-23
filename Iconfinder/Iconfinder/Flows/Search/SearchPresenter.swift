//
//  SearchPresenter.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

protocol iSearchPresenter {
    var viewModels: [IconViewModel] {get set}
    
    func getData()
}

class SearchPresenter: iSearchPresenter {
    
    weak var viewController: SearchViewController?
    
    var viewModels: [IconViewModel] = []
    
    func getData() {
        let model1 = IconViewModel(size: "320x512", tags: "tag1, taaaaag2, taggg3, tag4, taaagggg5, tag6, taaag7, taaaga8, tag9, taaaaag10")
        let model2 = IconViewModel(size: "6500x512", tags: "tag1")
        let model3 = IconViewModel(size: "320x512", tags: "tag1, taaaaag2, taggg3, tafffffg4, taaagggg5, tag6, taaag7, taaaga8, taffffffg9, taaaaag10")
        let model4 = IconViewModel(size: "6500x512", tags: "tag1, taaaaag2, taggg3")
        
        viewModels = [model1, model2, model3, model4]
        viewController?.reloadView()
    }
    
}
