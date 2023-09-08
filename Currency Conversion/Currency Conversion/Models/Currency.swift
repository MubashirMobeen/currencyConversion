//
//  Currency.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 05/08/2023.
//

import Foundation
import CoreData

// MARK: - CurrencyResponse
typealias CurrencyResponse = [String: String]

// MARK: - Currency
@objc(Currency)
public class Currency: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }
    
    @NSManaged public var code: String
    @NSManaged public var name: String
}
