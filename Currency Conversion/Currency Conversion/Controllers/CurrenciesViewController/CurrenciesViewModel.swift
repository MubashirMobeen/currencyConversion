//
//  CurrenciesViewModel.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 05/08/2023.
//

import Combine
import Foundation

final class CurrenciesViewModel {
    
    enum Input {
        case selectedCurrency(index: Int)
    }
    
    enum Output {
        case currencyUpdated(ex: Currency)
    }

    var output: AnyPublisher<Output, Never> { _output.eraseToAnyPublisher() }
    private let _output = PassthroughSubject<Output, Never>()
    
    private(set) var contentSize: CGSize = CGSize(width: 150, height: 150)
    private var list: [Currency]
    
    init(currencies: [Currency], contentSize: CGSize) {
        self.list = currencies
        self.contentSize = contentSize
    }
    
    func listCount() -> Int {
        list.count
    }
    
    func listItem(index: Int) -> Currency {
        list[index]
    }
    
    func input(_ input: Input) {
        switch input {
        case .selectedCurrency(let index):
            _output.send(.currencyUpdated(ex: listItem(index: index)))
        }
    }
}
