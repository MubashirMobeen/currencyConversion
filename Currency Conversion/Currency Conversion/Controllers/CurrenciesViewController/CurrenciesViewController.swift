//
//  CurrenciesViewController.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 05/08/2023.
//

import UIKit
import Anchorage

final class CurrenciesViewController: UIViewController {
    private var tableView = UITableView()
    
    private let viewModel: CurrenciesViewModel

    init(viewModel: CurrenciesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        updateUI()
    }
    
    private func configureUI() {
        configureTableView()
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: tableView.frame, style: .plain)
        view.addSubview(tableView)
        tableView.edgeAnchors == view.edgeAnchors
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.right = tableView.separatorInset.left
        tableView.contentInset.top = 5
        tableView.contentInset.bottom = 5

        tableView.delegate = self
        tableView.dataSource = self

        CurrencyTableViewCell.registerCell(with: tableView)
    }

    private func updateUI() {
        tableView.reloadData()
    }
}

extension CurrenciesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.listCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CurrencyTableViewCell.dequeueCell(from: tableView, atIndexPath: indexPath)
        cell.cellData = viewModel.listItem(index: indexPath.row)
        if (indexPath.row == (viewModel.listCount() - 1)) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
}

extension CurrenciesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.input(.selectedCurrency(index: indexPath.row))
        dismiss(animated: true)
    }
}
