//
//  FavoritesPresenter.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//

import UIKit
import CoreData

protocol iFavoritesPresenter {
    var viewModels: [IconViewModel] {get set}
    
    func getData()
    func removeAt(_ index: Int)
    func removeAll()
    func saveImageAt(_ index: Int)
}

class FavoritesPresenter: NSObject, iFavoritesPresenter {
    
    weak var viewController: FavoritesViewController?
    
    private let iconKeeper: IconDataKeeper
    var viewModels: [IconViewModel] = []
    private var models: [IconModel] = []
    
    init(iconKeeper: IconDataKeeper) {
        self.iconKeeper = iconKeeper
    }
    
    private lazy var frc: NSFetchedResultsController<FavoritesEntity> = {
        let request = FavoritesEntity.fetchRequest()
        request.sortDescriptors = [.init(key: "date", ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: (iconKeeper as! CoreDataStack).mainContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = viewController
        return frc
    }()
    
    func getData() {
        try? frc.performFetch()
        makeModels()
        viewController?.reloadView(showLabel: viewModels.isEmpty)
    }
    
    func removeAt(_ index: Int) {
        let icon = models[index]
        iconKeeper.deleteIcon(id: icon.id)
    }
    
    func removeAll() {
        iconKeeper.deleteAllIcons()
    }
    
    func saveImageAt(_ index: Int) {
        guard let image = viewModels[index].image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(savingStatus(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func savingStatus(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            viewController?.showToast(message: error.localizedDescription, success: false)
        } else {
            viewController?.showToast(message: SearchStrings.Alert.success, success: true)
        }
    }

    private func makeModels() {
        guard let objects = frc.fetchedObjects else { return }
        models = lastTen(objects).map { IconModel(id: $0.id ?? "", tags: $0.tags ?? "", size: $0.size ?? "", urlString: "", imageData: $0.imageData ?? Data())}
        viewModels = models.map { IconViewModel(image: UIImage(data: $0.imageData), size: $0.size, tags: $0.tags)}
    }
    
    private func lastTen(_ objects: [FavoritesEntity]) -> [FavoritesEntity] {
        guard objects.count > 10 else { return objects }
        var array = objects
        let tail = array.removeLast()
        iconKeeper.deleteIcon(id: tail.id ?? "")
        return array
    }
}
