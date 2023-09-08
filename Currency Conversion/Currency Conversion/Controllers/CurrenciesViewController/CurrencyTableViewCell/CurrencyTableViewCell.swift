//
//  CurrencyTableViewCell.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 05/08/2023.
//

import UIKit
import Foundation

final class CurrencyTableViewCell: UITableViewCell {

    var cellData: Currency? {
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
        content.text = cellData?.code
        content.secondaryText = cellData?.name
        
        contentConfiguration = content
    }
}
