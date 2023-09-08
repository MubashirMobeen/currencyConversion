//
//  CoreDataManager.swift
//  Currency Conversion
//
//  Created by Muhammad Mubashir on 06/08/2023.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocalStorage")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func storeExchangeRates(_ exchangeRates: [String: Double], completion: ((Bool) -> Void)? = nil) {
        deleteExchangeRates()
        let context = CoreDataManager.shared.context
        
        for (currencyCode, exchangeRate) in exchangeRates {
            let currency = ExchangeRate(context: context)
            currency.code = currencyCode
            currency.rate = exchangeRate
        }
        
        do {
            try context.save()
            completion?(true)
        } catch {
            print("Failed to save Core Data context: \(error)")
            completion?(false)
        }
    }
    
    func storeCurrency(_ currency: [String: String], completion: ((Bool) -> Void)? = nil) {
        deleteCurrency()
        let context = CoreDataManager.shared.context
        
        for (currencyCode, currencyName) in currency {
            let currency = Currency(context: context)
            currency.code = currencyCode
            currency.name = currencyName
        }
        
        do {
            try context.save()
            completion?(true)
        } catch {
            print("Failed to save Core Data context: \(error)")
            completion?(false)
        }
    }
    
    func fetchExchangeRatesFromCoreData() -> [ExchangeRate] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<ExchangeRate> = ExchangeRate.fetchRequest()
        
        do {
            let exchangeRates = try context.fetch(fetchRequest)
            return exchangeRates
        } catch {
            print("Failed to fetch exchange rates from Core Data: \(error)")
            return []
        }
    }
    
    func fetchCurrencyFromCoreData() -> [Currency] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        
        do {
            let currencies = try context.fetch(fetchRequest)
            return currencies
        } catch {
            print("Failed to fetch exchange rates from Core Data: \(error)")
            return []
        }
    }
    
    func isExchangeRatesExists() -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<ExchangeRate> = ExchangeRate.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch exchange rates from Core Data: \(error)")
            return false
        }
    }

    func isCurrencyExists() -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Currency> = Currency.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch exchange rates from Core Data: \(error)")
            return false
        }
    }
    
    private func deleteExchangeRates() {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExchangeRate")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to fetch exchange rates from Core Data: \(error)")
        }
    }
    
    private func deleteCurrency() {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Currency")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to fetch exchange rates from Core Data: \(error)")
        }
    }
}
