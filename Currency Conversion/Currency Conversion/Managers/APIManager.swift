//
//  APIManager.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 05/08/2023.
//

import Alamofire
import Foundation

class APIManager {
    
    private enum URLs: String {
        case openExchangeRatesBaseURL = "https://openexchangerates.org/api/"
    }
    
    private enum EndPoints: String {
        case fetchAllCurrencies = "currencies.json"
        case fetchLatestExchangeRates = "latest.json"
    }
    
    private enum CustomError: Error {
        case invalidURL
        case invalidResponse
    }
    
    static let shared = APIManager()
    private let openExchangeRatesAPPID = "a5f9634adacd4ea3bbe5b4f25d4d53d6"
    
//    MARK: - Fetch Currencies List API (GET Method)
    func fetchCurrenciesList(completion: @escaping (Result <CurrencyResponse, Error>) -> Void) {
        let url = URLs.openExchangeRatesBaseURL.rawValue + EndPoints.fetchAllCurrencies.rawValue
        
        callService(
            url: url,
            method: .get,
            parameters: nil,
            headers: nil,
            expecting: CurrencyResponse.self) { result in
                completion(result)
            }
    }
    
//    MARK: - Fetch Currency Exchange Rates List API (GET Method)
    func fetchCurrencyExchangeRates(baseCurrency: String = "USD", completion: @escaping (Result <ExchangeRateResponse, Error>) -> Void) {
        let url = URLs.openExchangeRatesBaseURL.rawValue + EndPoints.fetchLatestExchangeRates.rawValue
        var urlComps = URLComponents(string: url)
        urlComps?.queryItems = [URLQueryItem(name: "app_id", value: openExchangeRatesAPPID),
                                URLQueryItem(name: "base", value: baseCurrency)]
        let finalUrl = urlComps?.url?.absoluteString
        
        callService(
            url: finalUrl,
            method: .get,
            parameters: nil,
            headers: nil,
            expecting: ExchangeRateResponse.self) { result in
                completion(result)
            }
    }
}

extension APIManager {
//    MARK: - Common Method to call API services
    private func callService<T: Codable>(
        url: String?,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        expecting: T.Type,
        completion: @escaping (Result <T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(CustomError.invalidURL))
            return
        }
        print(url)
        print(parameters ?? "nil")
        
        AF.request(url, method: method, parameters: parameters, headers: headers)
            .response (completionHandler: { response in
                guard let data = response.data else {
                    if let error = response.error {
                        completion(.failure(error))
                    }
                    else {
                        completion(.failure(CustomError.invalidResponse))
                    }
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(expecting, from: data)
                    print(result)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            })
    }
}
