//
//  SearchView.swift
//  Iconfinder
//
//  Created by Aleksandr Fetisov on 23.06.2024.
//

import UIKit

class SearchView: UIView {
    
    private lazy var tableView = {
        $0.separatorStyle = .none
        $0.backgroundColor = .systemGray6
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
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
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configureTableView(refreshControl: UIRefreshControl) {
        tableView.refreshControl = refreshControl
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
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
}
