//
//  ConversionViewModel.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 05/08/2023.
//

import Combine
import Foundation
import CoreData

final class ConversionViewModel {
    enum Input {
        case viewDidLoad
        case updateConversionByAmount(String?)
    }
    
    enum Output {
        case updateUI
    }
    
    func input(_ input: Input) {
        switch input {
        case .viewDidLoad:
            fetchData()
        case .updateConversionByAmount(let value):
            updateConversionByAmount(value: value)
        }
    }
    
    var output: AnyPublisher<Output, Never> { _output.eraseToAnyPublisher() }
    private var cancelBag = Set<AnyCancellable>()
    private let _output = PassthroughSubject<Output, Never>()
    
    private let timeIntervalToRefreshData: TimeInterval = 30 * 60 // Change minutes only i.e 30
    private var amountToConvert: Double = 1.0
    private var currencies: [Currency] = []
    private var exchangeRates: [ExchangeRate] = []
    private(set) var selectedCurrency: String = "USD"
    private var selectedCurrencyValue: Double = 1.0
    
    func getCurrenciesViewModel(size: CGSize) -> CurrenciesViewModel {
        let viewModel = CurrenciesViewModel(currencies: currencies, contentSize: size)
        viewModel.output.sink { [weak self] output in
            guard let self = self else { return }
            switch output {
            case .currencyUpdated(let currency):
                self.selectedCurrency = currency.code
                self.selectedCurrencyValue = self.exchangeRates.first(where: { exchangeRate in
                    exchangeRate.code == currency.code
                })?.rate ?? 0.0
                self._output.send(.updateUI)
            }
        }.store(in: &cancelBag)
        return viewModel
    }
    
    func getSuggestedCurrencyConversionTableViewCellViewModel(for index: Int) -> SuggestedCurrencyConversionTableViewCellViewModel {
        
        let exchangeRate = exchangeRates[index]
        let code = exchangeRate.code
        let rate = convertBetweenCurrencies(amount: amountToConvert, fromCurrencyValue: selectedCurrencyValue, toCurrencyValue: exchangeRate.rate)
        let viewModel = SuggestedCurrencyConversionTableViewCellViewModel(code: code, rate: rate)
        return viewModel
    }
    
    func getSuggestedCurrencyConversionCount() -> Int {
        exchangeRates.count
    }
    
    private func updateConversionByAmount(value: String?) {
        amountToConvert = Double(value ?? "0.0") ?? 0.0
        _output.send(.updateUI)
    }
    
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        if shouldFetchCurrencies() {
            fetchAllCurrencies(group: dispatchGroup)
        } else {
            currencies = CoreDataManager.shared.fetchCurrencyFromCoreData().sorted{$0.code < $1.code}
        }
        if shouldFetchExchangeRates() {
            fetchLatestExchangeRates(group: dispatchGroup)
        } else {
            exchangeRates = CoreDataManager.shared.fetchExchangeRatesFromCoreData().sorted{$0.code < $1.code}
        }
        
        dispatchGroup.notify(queue: .main) {
            self._output.send(.updateUI)
        }
    }
    
    private func fetchAllCurrencies(group: DispatchGroup? = nil) {
        group?.enter()
        APIManager.shared.fetchCurrenciesList { result in
            switch result {
            case .success(let response):
                CoreDataManager.shared.storeCurrency(response)
                UserDefaultsManager.shared.currencyFetchTime = Date()
                self.currencies = CoreDataManager.shared.fetchCurrencyFromCoreData().sorted{$0.code < $1.code}
            case .failure(let error):
                print("<<<<<Error occurred>>>> ", error.localizedDescription)
            }
            group?.leave()
        }
    }
    
    private func fetchLatestExchangeRates(group: DispatchGroup? = nil) {
        group?.enter()
        APIManager.shared.fetchCurrencyExchangeRates { result in
            switch result {
            case .success(let response):
                guard let rates = response.rates else { return }
                CoreDataManager.shared.storeExchangeRates(rates)
                UserDefaultsManager.shared.exchangeRateFetchTime = Date()
                self.exchangeRates = CoreDataManager.shared.fetchExchangeRatesFromCoreData().sorted{$0.code < $1.code}
            case .failure(let error):
                print("<<<<<Error occurred>>>> ", error.localizedDescription)
            }
            group?.leave()
        }
    }
    
    private func shouldFetchExchangeRates() -> Bool {
        if CoreDataManager.shared.isExchangeRatesExists() {
            let lastFetched = UserDefaultsManager.shared.exchangeRateFetchTime ?? Date()
            return (lastFetched.addingTimeInterval(timeIntervalToRefreshData) <= Date())
        }
        else {
            return true
        }
    }
    
    private func shouldFetchCurrencies() -> Bool {
        if CoreDataManager.shared.isCurrencyExists() {
            let lastFetched = UserDefaultsManager.shared.currencyFetchTime ?? Date()
            return (lastFetched.addingTimeInterval(timeIntervalToRefreshData) <= Date())
        }
        else {
            return true
        }
    }
}

//MARK: - CurrencyConversion Logical Handling
extension ConversionViewModel {
    func convertToUSD(amount: Double, value: Double) -> Double {
        return amount / value
    }
    
    func convertFromUSD(amount: Double, value: Double) -> Double {
        return amount * value
    }
    
    func convertBetweenCurrencies(amount: Double, fromCurrencyValue: Double, toCurrencyValue: Double) -> Double {
        let usdAmount = convertToUSD(amount: amount, value: fromCurrencyValue)
        let convertedAmount = convertFromUSD(amount: usdAmount, value: toCurrencyValue)
        return convertedAmount
    }
}
