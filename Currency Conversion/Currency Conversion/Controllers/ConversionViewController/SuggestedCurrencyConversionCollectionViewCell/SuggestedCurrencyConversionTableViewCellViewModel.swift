//
//  SuggestedCurrencyConversionTableViewCellViewModel.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 06/08/2023.
//

import Foundation

final class SuggestedCurrencyConversionTableViewCellViewModel {
    var nameText: String {
        code
    }
    
    var priceText: String? {
        rate.getDoubleString()
    }
    
    private let code: String
    private let rate: Double
    
    init(code: String, rate: Double) {
        self.code = code
        self.rate = rate
    }
}
