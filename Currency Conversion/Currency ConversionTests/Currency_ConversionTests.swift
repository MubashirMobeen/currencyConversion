//
//  Currency_ConversionTests.swift
//  Currency ConversionTests
//
//  Created by Muhammad Mubashir on 01/08/2023.
//

import XCTest
@testable import Currency_Conversion

final class Currency_ConversionTests: XCTestCase {
    
    var conversionViewModel: ConversionViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        conversionViewModel = ConversionViewModel()
    }
    
    func testConvertToUSD() {
        let value = conversionViewModel.convertToUSD(amount: 10.0, value: 1)
        XCTAssertEqual(value, 10.0)
    }
    
    func testConvertFromUSD() {
        let value = conversionViewModel.convertFromUSD(amount: 1.0, value: 283.0)
        XCTAssertEqual(value, 283.0)
    }
    
    func testConvertBetweenCurrencies() {
        let value = conversionViewModel.convertBetweenCurrencies(amount: 10, fromCurrencyValue: 281.64, toCurrencyValue: 3.67)
        XCTAssertEqual(value, 0.13, accuracy: 0.1)
    }
    
    func testFetchExchangeRates() {
        let expectation = self.expectation(description: "It will return some data and not nil in case of success")
        APIManager.shared.fetchCurrencyExchangeRates { result in
            switch result {
            case .success(let response):
                guard let rates = response.rates else { return }
                XCTAssertNotNil(rates)
            case .failure(let error):
                XCTAssertNil(true)
                print("<<<<<Error occurred>>>> ", error.localizedDescription)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 60)
    }
    
    func testFetchCurrency() {
        let expectation = self.expectation(description: "It will return some data and not nil in case of success")
        APIManager.shared.fetchCurrenciesList { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
            case .failure(let error):
                XCTAssertNil(true)
                print("<<<<<Error occurred>>>> ", error.localizedDescription)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 60)
    }

}
