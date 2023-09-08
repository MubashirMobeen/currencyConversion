//
//  ConversionViewController.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 01/08/2023.
//

import UIKit
import Combine

class ConversionViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var baseCurrencyDropdownButton: UIButton!
    @IBOutlet weak var conversionsTableView: UITableView!
    
    private var viewModel: ConversionViewModel = ConversionViewModel()
    private var cancelBag = Set<AnyCancellable>()
    
    let cdman = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
        configureBindings()
        viewModel.input(.viewDidLoad)
    }
    
    private func configureUI() {
        configureDropdownButton()
        configureConversionsTableView()
        configureTapGesture()
        amountTextField.delegate = self
        amountTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func configureDropdownButton() {
        baseCurrencyDropdownButton.layer.cornerRadius = 4
        baseCurrencyDropdownButton.layer.borderWidth = 0.4
        baseCurrencyDropdownButton.layer.borderColor = UIColor.black.withAlphaComponent(0.2).cgColor
    }
    
    private func configureConversionsTableView() {
        SuggestedCurrencyConversionTableViewCell.registerCell(with: conversionsTableView)
        
        conversionsTableView.dataSource = self
    }
    
    private func configureTapGesture() {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.input(.updateConversionByAmount(textField.text))
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer? = nil) {
        if amountTextField.isFirstResponder {
            amountTextField.resignFirstResponder()
        }
    }
    
    private func updateUI() {
        self.baseCurrencyDropdownButton.setTitle(viewModel.selectedCurrency, for: .normal)
        self.conversionsTableView.reloadData()
    }
    
    private func configureBindings() {
        viewModel.output.sink { [weak self] output in
            guard let self = self else { return }
            switch output {
            case .updateUI:
                self.updateUI()
            }
        }.store(in: &cancelBag)
    }

    @IBAction func baseCurrencyButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        let viewModel = viewModel.getCurrenciesViewModel(size: CGSize(width: baseCurrencyDropdownButton.frame.width, height: (view.frame.height * 0.5)))
        let viewController = CurrenciesViewController(viewModel: viewModel)
        viewController.preferredContentSize = viewModel.contentSize
        viewController.modalPresentationStyle = .popover
        if let pres = viewController.presentationController {
            pres.delegate = self
        }

        if let pop = viewController.popoverPresentationController {
            pop.sourceView = sender
            pop.sourceRect = sender.bounds
        }

        present(viewController, animated: true)
    }
}

extension ConversionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getSuggestedCurrencyConversionCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SuggestedCurrencyConversionTableViewCell.dequeueCell(from: tableView, atIndexPath: indexPath)
        cell.viewModel = viewModel.getSuggestedCurrencyConversionTableViewCellViewModel(for: indexPath.row)
        if (indexPath.row == (viewModel.getSuggestedCurrencyConversionCount() - 1)) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
}

extension ConversionViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

extension ConversionViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        // Only allow numeric characters
        let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
        let characterSet = CharacterSet(charactersIn: string)
        if !characterSet.isSubset(of: allowedCharacters) {
            return false
        }
        // Handle decimal point
        if string == "." {
            if text.contains(".") {
                // Disallow multiple decimal points
                return false
            }
        }
        
        // Handle leading zeros
        if text == "0" && string != "." {
            textField.text = string
            return false
        }
        if string == "." && text == "" {
            textField.text = "0."
            return false
        }
        return true
    }
}
