//
//  SearchPresenter.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

protocol iSearchPresenter {
    var viewModels: [IconViewModel] {get set}
    
    func findIcons(with query: String?)
    func clearSearch()
    func saveImageAt(_ index: Int)
}

class SearchPresenter: NSObject, iSearchPresenter {
    
    weak var viewController: SearchViewController?
    let networkService: iSearchNetworkService
    var viewModels: [IconViewModel] = []
    private var models: [IconModel] = []
    private var pageNumber: Int = 0
    private var totalCount: Int?
    private var searchText: String?
    
    init(networkService: iSearchNetworkService) {
        self.networkService = networkService
    }
    
    func clearSearch() {
        searchText = nil
        refresh()
        getData()
    }
    
    func findIcons(with query: String?) {
        if searchText != query {
            searchText = query
            refresh()
            getData()
        }
    }
    
    func refresh() {
        pageNumber = 1
        totalCount = nil
        models.removeAll()
        viewModels.removeAll()
        viewController?.reloadView(showLabel: false)
    }

    
    func getData() {
        if let totalCount = totalCount {
            guard totalCount >= pageNumber*10 else { return }
        }
        
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

                for (index,model) in iconModels.enumerated() {
                    let imageData = try await fetchImage(model: model)
                    let imageIndex = models.isEmpty ? index : models.count - iconModels.count + index
                    guard viewModels.count >= imageIndex else { return }
                    if let image = UIImage(data: imageData) {
                        viewModels[imageIndex].image = image
                        await viewController?.reloadRowAt(index: imageIndex)
                    }
                }
            } catch(let error) {
                await viewController?.showToast(message: error.localizedDescription, success: false)
            }
        }
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
    
    private func fetchImage(model: IconModel) async throws -> Data {
        let imageData = try await networkService.fetchFile(url: model.urlString)
        return imageData
    }
    
    private func makeModel(_ model: Icon) -> IconModel {
        let maxSize = model.rasterSizes.map({$0.size}).max()
        let maxSizedModel = model.rasterSizes.filter({$0.size == maxSize }).first
        let size = "\(maxSizedModel?.sizeWidth ?? 0) x \(maxSizedModel?.sizeHeight ?? 0)"
        let urlString = maxSizedModel?.formats.filter({$0.format == "png"}).first?.imageUrl
        let tags = model.tags.prefix(10).joined(separator: ", ")
        let model = IconModel(id: String(model.iconID), date: Date(), tags: tags, size: size, urlString: urlString ?? "", imageData: nil)
        return model
    }
    
}
