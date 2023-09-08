//
//  SuggestedCurrencyConversionTableViewCell.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 06/08/2023.
//

import UIKit
import Combine
import Anchorage

class SuggestedCurrencyConversionTableViewCell: UITableViewCell {
    
    var viewModel: SuggestedCurrencyConversionTableViewCellViewModel? {
        didSet {
            updateUI()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        var content = defaultContentConfiguration()
        content.text = viewModel?.nameText
        content.secondaryText = viewModel?.priceText
        
        contentConfiguration = content
    }
}
