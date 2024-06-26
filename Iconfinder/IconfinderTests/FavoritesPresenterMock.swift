//
//  SearchPresenterMock.swift
//  IconfinderTests
//
//  Created by Aleksandr Fetisov on 26.06.2024.
//

import Foundation
@testable import Iconfinder

class FavoritesPresenterMock: iFavoritesPresenter {
    
    var getDataWasCalled = false
    func getData() {
        getDataWasCalled = true
    }
    
    var removeAllWasCalled = false
    func removeAll() {
        removeAllWasCalled = true
    }
    
    // MARK: в тесте не использованы
    var viewModels: [Iconfinder.IconViewModel] = []
    func removeAt(_ index: Int) {}
    func saveImageAt(_ index: Int) {}
}
