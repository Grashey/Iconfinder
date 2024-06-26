//
//  SpinnerManager.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 26.06.2024.
//

import UIKit

class SpinnerManager: UIViewController {

    private let spinner = SpinnerController()

    var isLoading = false {
        didSet {
            guard oldValue != isLoading else { return }
            showSpinner(isShown: isLoading)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.view.frame = view.frame
    }

    private func showSpinner(isShown: Bool) {
        DispatchQueue.main.async { [unowned self] in
            if isShown {
                addChild(spinner)
                view.addSubview(spinner.view)
                spinner.didMove(toParent: self)
            } else {
                spinner.willMove(toParent: nil)
                spinner.view.removeFromSuperview()
                spinner.removeFromParent()
            }
        }
    }
}
