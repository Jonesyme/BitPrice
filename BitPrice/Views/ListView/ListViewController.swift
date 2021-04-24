//
//  ListViewController.swift
//  BitPrice
//
//  Created by Mike Jones on 2/23/21.
//  Copyright © 2021 Mike Jones. All rights reserved.
//

import UIKit


class ListViewController: UIViewController {
    
    private var viewModel: ListViewModel!
    private var livePriceRefetchTimer: Timer?
    private weak var coordinator: Coordinator!
    
    lazy private var backgroundView: UIImageView = {
        let bgView = UIImageView(image: UIImage(named: "bgBlackCloth"))
        bgView.translatesAutoresizingMaskIntoConstraints = false
        return bgView }()

    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshAllTableData), for: .valueChanged)
        return refreshControl }()
    
    lazy internal var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nibName: LivePriceCell.cellIdentifier())
        tableView.register(nibName: PriceCell.cellIdentifier())
        return tableView }()

    
    static func createInstance(viewModel: ListViewModel, coordinator: Coordinator) -> ListViewController {
        let viewController = ListViewController()
        viewController.coordinator = coordinator
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        refreshAllTableData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.livePriceRefetchTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { [weak self] _ in
            self?.viewModel.fetchLivePrice()
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.livePriceRefetchTimer?.invalidate()
    }
    
    private func setupView() {
        self.title = "Price List"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "toolbarTan"), for: .default)
        view.addSubview(backgroundView)
        view.addConstraints(backgroundView.edgeConstraints(to: view))
        view.addSubview(tableView)
        view.addConstraints(tableView.edgeConstraints(to: view))
    }
    
    private func bindViewModel() {
        viewModel.delegate = self
    }
    
    @objc private func refreshAllTableData() {
        viewModel.fetchLivePrice()
        viewModel.fetchHistoricPrices()
    }

}


extension ListViewController: ViewModelBindingDelegate {
    
    func updateView(_ errorMessage: String? = nil) {
        self.refreshControl.endRefreshing()
        if let message = errorMessage {
            showAlert(title: "Connection Issue", message: message)
        }
    }
    
}


extension ListViewController: UITableViewDataSource, UITableViewDelegate {

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.item(atRow: indexPath.row)
        if let coordinator = coordinator as? ListCoordinator, let priceRecord = cellViewModel.priceRecord.value {
            coordinator.showDetailView(forPriceRecord: priceRecord)
        }
    }
    
}

