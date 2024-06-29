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
    
    private lazy var noResultsLabel: UILabel = {
        $0.isHidden = true
        $0.text = SearchStrings.Title.noResults
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
    
    func configureTableView(refreshControl: UIRefreshControl) {
        tableView.refreshControl = refreshControl
    }
    
    func configureTableView(delegateAndDataSourse: UITableViewDelegate & UITableViewDataSource) {
        tableView.delegate = delegateAndDataSourse
        tableView.dataSource = delegateAndDataSourse
    }
    
    func configureTableView(cell: AnyClass) {
        tableView.register(cell, forCellReuseIdentifier: cell.description())
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func reloadRows(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .none)
    }
    
    func showNoResults(_ isHidden: Bool) {
         noResultsLabel.isHidden = !isHidden
    }
}
