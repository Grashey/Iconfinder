//
//  SearchPresenter.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

protocol iSearchPresenter {
    var viewModels: [IconViewModel] {get set}
    
    func clearSearch()
    func findIcons(with query: String?)
    func saveImageAt(_ index: Int)
    func serveFavorites(index: Int)
    func isFavorite(index: Int) -> Bool
    func fetchData()
    func refresh()
    func updateImageFor(_ index: Int)
}

class SearchPresenter: NSObject, iSearchPresenter {
    
    weak var viewController: SearchViewController?
    private let networkService: iSearchNetworkService
    private let iconKeeper: IconDataKeeper
    private let imageKeeper: ImageDataKeeper
    var viewModels: [IconViewModel] = []
    private var models: [IconModel] = []
    private var pageNumber: Int = 0
    private var totalCount: Int?
    private var searchText: String?
    var isLoading: Bool = false {
        didSet {
            viewController?.isLoading = isLoading
        }
    }
    
    init(networkService: iSearchNetworkService, iconKeeper: IconDataKeeper, imageKeeper: ImageDataKeeper) {
        self.networkService = networkService
        self.iconKeeper = iconKeeper
        self.imageKeeper = imageKeeper
    }
    
    func clearSearch() {
        searchText = nil
        refresh()
        fetchData()
    }
    
    func findIcons(with query: String?) {
        if searchText != query {
            searchText = query
            refresh()
            fetchData()
        }
    }
    
    func saveImageAt(_ index: Int) {
        guard let image = viewModels[index].image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(savingStatus(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func serveFavorites(index: Int) {
        let icon = models[index]
        if iconKeeper.checkIcon(id: icon.id) {
            iconKeeper.deleteIcon(id: icon.id)
        } else {
            iconKeeper.addIconEntity(id: icon.id, date: Date(), tags: icon.tags, size: icon.size, imageData: icon.imageData)
        }
        viewController?.reloadRowAt(index: index)
    }
    
    func isFavorite(index: Int) -> Bool {
        let icon = models[index]
        return iconKeeper.checkIcon(id: icon.id)
    }
    
    func fetchData() {
        if let totalCount = totalCount {
            guard totalCount >= pageNumber*10 else { return }
        }
        isLoading = true
        Task {
            do {
                let data = try await networkService.searchPhotos(searchText, page: pageNumber)
                let response = try JSONDecoder().decode(IconResponse.self, from: data)
                totalCount = response.totalCount
                let iconModels = response.icons.map({ makeModel($0)})
                models += iconModels
                viewModels += iconModels.map({ IconViewModel(size: $0.size, tags: $0.tags)})
                await viewController?.reloadView(showLabel: viewModels.isEmpty)
                pageNumber += 1
                isLoading = false
            } catch(let error) {
                await viewController?.showToast(message: error.localizedDescription, success: false)
                isLoading = false
            }
        }
    }
    
    func refresh() {
        pageNumber = 0
        totalCount = nil
        models.removeAll()
        viewModels.removeAll()
        viewController?.reloadView(showLabel: false)
    }
    
    func updateImageFor(_ index: Int) {
        Task {
            do {
                let model = models[index]
                let imageData = try await getImageDataFor(model: model)
                if let image = UIImage(data: imageData) {
                    models[index].imageData = imageData
                    viewModels[index].image = image
                    await viewController?.reloadRowAt(index: index)
                }
            } catch {
                await viewController?.showToast(message: error.localizedDescription, success: false)
            }
        }
    }
    
    private func getImageDataFor(model: IconModel) async throws -> Data {
        var imageData: Data
        if let data = imageKeeper.checkImage(id: model.id) {
            imageData = data
        } else {
            let data = try await networkService.fetchFile(url: model.urlString)
            imageKeeper.addImageEntity(id: model.id, imageData: data)
            imageData = data
        }
        return imageData
    }
    
    @objc private func savingStatus(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            viewController?.showToast(message: error.localizedDescription, success: false)
        } else {
            viewController?.showToast(message: SearchStrings.Alert.success, success: true)
        }
    }
    
    private func makeModel(_ model: Icon) -> IconModel {
        let maxSize = model.rasterSizes.map({$0.size}).max()
        let maxSizedModel = model.rasterSizes.filter({$0.size == maxSize}).first
        let size = "\(maxSizedModel?.sizeWidth ?? .zero) x \(maxSizedModel?.sizeHeight ?? .zero)"
        let urlString = maxSizedModel?.formats.filter({$0.format == "png"}).first?.imageUrl ?? ""
        let tags = model.tags.prefix(10).joined(separator: ", ")
        let model = IconModel(id: String(model.iconID), tags: tags, size: size, urlString: urlString, imageData: Data())
        return model
    }
    
}
