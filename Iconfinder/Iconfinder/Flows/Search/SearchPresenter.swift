//
//  SearchPresenter.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

protocol iSearchPresenter {
    var viewModels: [IconViewModel] {get set}
    
    func getData(with query: String?)
}

class SearchPresenter: iSearchPresenter {
    
    weak var viewController: SearchViewController?
    let networkService: iSearchNetworkService
    var viewModels: [IconViewModel] = []
    private var models: [IconModel] = []
    private var pageNumber: Int = 0
    
    init(networkService: iSearchNetworkService) {
        self.networkService = networkService
    }
    
    func getData(with query: String?) {
        Task {
            do {
                let data = try await networkService.searchPhotos(query, page: pageNumber)
                let response = try JSONDecoder().decode(IconResponse.self, from: data)
                let iconModels = response.icons.map({ makeModel($0)})
                models += iconModels
                viewModels += iconModels.map({ IconViewModel(size: $0.size, tags: $0.tags)})
                await viewController?.reloadView()
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
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchImage(model: IconModel) async throws -> Data {
        let imageData = try await networkService.fetchFile(url: model.urlString)
        return imageData
    }
    
    func makeModel(_ model: Icon) -> IconModel {
        let maxSize = model.rasterSizes.map({$0.size}).max()
        let maxSizedModel = model.rasterSizes.filter({$0.size == maxSize }).first
        let size = "\(maxSizedModel?.sizeWidth ?? 0) x \(maxSizedModel?.sizeHeight ?? 0)"
        let urlString = maxSizedModel?.formats.filter({$0.format == "png"}).first?.imageUrl
        let tags = model.tags.prefix(10).joined(separator: ", ")
        let model = IconModel(id: String(model.iconID), date: Date(), tags: tags, size: size, urlString: urlString ?? "", imageData: nil)
        return model
    }
    
}
