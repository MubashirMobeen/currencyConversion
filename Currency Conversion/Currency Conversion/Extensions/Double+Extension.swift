//
//  Double+Extension.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 07/08/2023.
//

import Foundation

extension Double {
    func getDoubleString(in maxDecimalDigits: Int = 6) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = maxDecimalDigits
        numberFormatter.usesGroupingSeparator = false
        guard let valueString = numberFormatter.string(for: self) else { return nil }
        return valueString
    }
}
