//
//  DetailViewController.swift
//  BitPrice
//
//  Created by Mike Jones on 2/25/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {
    
    private var viewModel: DetailViewModel!
    private weak var coordinator: Coordinator!
    
    lazy private var backgroundView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "bgBlackCloth"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view }()
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshTableData(_:)), for: .valueChanged)
        return refreshControl }()
    
    lazy internal var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibName: CurrencyCell.cellIdentifier())
        return tableView }()

    
    static func createInstance(viewModel: DetailViewModel, coordinator: Coordinator) -> DetailViewController {
        let viewController = DetailViewController()
        viewController.coordinator = coordinator
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.tearDown()
    }
    
    private func setupView() {
        self.title = viewModel.title
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        view.addConstraints(backgroundView.edgeConstraints(to: view))
        view.addConstraints(tableView.edgeConstraints(to: view))
    }
    
    @objc private func refreshTableData(_ sender: Any?) {
        viewModel.fetchData()
    }
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
}

extension DetailViewController: ViewModelBindingDelegate {
    
    func updateView(_ errorMessage: String? = nil) {
        self.refreshControl.endRefreshing()
        if let message = errorMessage {
            showAlert(title: "Connection Issue", message: message)
        }
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.item(atRow: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
        if let cell = cell as? TableCell {
            cell.configureCell(with: cellViewModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.item(atRow: indexPath.row).cellRowHeight
    }
    
}

