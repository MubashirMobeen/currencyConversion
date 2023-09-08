//
//  UserDefaultsManager.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 06/08/2023.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults: UserDefaults = .standard

    var currencyFetchTime: Date? {
        get {
            return userDefaults.value(forKey: UserDefaultkeys.currencyFetchTime.rawValue) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultkeys.currencyFetchTime.rawValue)
        }
    }
    
    var exchangeRateFetchTime: Date? {
        get {
            return userDefaults.value(forKey: UserDefaultkeys.exchangeRateFetchTime.rawValue) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultkeys.exchangeRateFetchTime.rawValue)
        }
    }
    
    func clearPreferences(){
        userDefaults.removeObject(forKey: UserDefaultkeys.currencyFetchTime.rawValue)
        userDefaults.removeObject(forKey: UserDefaultkeys.exchangeRateFetchTime.rawValue)
    }
}

fileprivate enum UserDefaultkeys: String {
    case currencyFetchTime = "currency_fetch_time"
    case exchangeRateFetchTime = "exchange_rate_fetch_time"
}
