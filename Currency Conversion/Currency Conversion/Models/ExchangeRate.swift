//
//  ExchangeRate.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 05/08/2023.
//

import Foundation
import CoreData

// MARK: - ExchangeRateResponse
struct ExchangeRateResponse: Codable {
    let disclaimer: String?
    let license: String?
    let timestamp: Int?
    let base: String?
    let rates: [String: Double]?
}

// MARK: - ExchangeRate
@objc(ExchangeRate)
public class ExchangeRate: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExchangeRate> {
        return NSFetchRequest<ExchangeRate>(entityName: "ExchangeRate")
    }
    
    @NSManaged public var code: String
    @NSManaged public var rate: Double
}
