//
//  FavoritesView.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 25.06.2024.
//

import UIKit

class FavoritesView: UIView {
    
    private lazy var tableView = {
        $0.separatorStyle = .none
        $0.backgroundColor = .systemGray6
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    private lazy var noResultsLabel: UILabel = {
        $0.isHidden = true
        $0.text = FavoritesStrings.Title.noItems
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        addConstraints()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(tableView)
        addSubview(noResultsLabel)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            noResultsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            noResultsLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func configureTableView(delegateAndDataSourse: UITableViewDelegate & UITableViewDataSource) {
        tableView.delegate = delegateAndDataSourse
        tableView.dataSource = delegateAndDataSourse
    }
    
    func configureTableView(cell: AnyClass, with identifier: String) {
        tableView.register(cell, forCellReuseIdentifier: identifier)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func showNoResults(_ isHidden: Bool) {
         noResultsLabel.isHidden = !isHidden
    }
}
