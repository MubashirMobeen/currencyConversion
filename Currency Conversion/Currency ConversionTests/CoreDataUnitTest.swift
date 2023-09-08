//
//  CoreDataUnitTest.swift
//  Currency ConversionTests
//
//  Created by Muhammad Mubashir on 07/08/2023.
//

import XCTest
@testable import Currency_Conversion

final class CoreDataUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testStoreCurrencyData() {
        let data = ["AED": "United Arab Emirates Dirham",
                    "PKR": "Pakistani Rupee",
                    "USD": "United States Dollar"]
        CoreDataManager.shared.storeCurrency(data) { status in
            XCTAssertTrue(status)
        }
    }
    
    func testFetchCurrency() {
        let curreny = CoreDataManager.shared.fetchCurrencyFromCoreData()
        XCTAssertNotNil(curreny)
    }
    
    func testStoreExchangeRateData() {
        let data = ["AED": 323.0,
                    "PKR": 234.435,
                    "USD": 537.00]
        CoreDataManager.shared.storeExchangeRates(data) { status in
            XCTAssertTrue(status)
        }
    }
    
    func testFetchExchangeRates() {
        let exchangeRates = CoreDataManager.shared.fetchExchangeRatesFromCoreData()
        XCTAssertNotNil(exchangeRates)
    }
}
