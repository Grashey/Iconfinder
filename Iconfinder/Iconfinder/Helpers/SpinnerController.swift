//
//  SpinnerController.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 26.06.2024.
//

import UIKit

class SpinnerController: UIViewController {

    private let spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = .clear
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        spinner.startAnimating()
    }
}
