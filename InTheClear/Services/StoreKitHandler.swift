//
//  StoreKitHandler.swift
//  InTheClear
//
//  Created by Josh Sauder on 11/8/21.
//  Copyright © 2021 Josh Sauder. All rights reserved.
//

import Foundation
import StoreKit

class StoreKitHandler {
    
    let productIdentifiers: Set<String>
    let currencyFormatter: NumberFormatter
    let skProducts: Dictionary<String, SKProduct>
    
    init() {
        productIdentifiers = Set<String>(["premium"])
        super.init()
        currencyFormatter.numberStyle = .currency
        SKPaymentQueue.default().add(self)
    }
    
    func getAppStoreProducts(){
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }
}

extension StoreKitHandler: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers.forEach({ assert($0.count > 0, "Invalid product identifier \($0)")})
        response.products.forEach({ self.skProducts[$0.productIdentifier] = $0})
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error while fetching store requests")
    }
}

extension StoreKitHandler {
    func purchaseAnnualSubscription(){
        
    }
    
    func purchase(product: String){
        guard let skProduct = skProducts[product] else { return }
        SKPaymentQueue.default().add(SKPayment(product: skProduct))
    }
    
    func restorePreviousPurchase(){
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension StoreKitHandler: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var purchaseCompleteSubscription: Bool = false
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("Purchasing: \(transaction.payment.productIdentifier)")
            case .purchased:
                print("Purchased: \(transaction.payment.productIdentifier)")
            case .restored:
                print("Restored: \(transaction.payment.productIdentifier)")
            case .failed:
                print("Failed: \(transaction.payment.productIdentifier)")
            default:
                print("Purchase Queue: Default")
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        // Tells observer payment queue finished restoring purchases
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("Restore Failed")
    }
}

extension StoreKitHandler {
    private func price(forProduct productKey: String) -> String? {
        let currencyFormatter = NumberFormatter()
        guard let skProduct = skProducts[productKey] else { return nil }
        currencyFormatter.locale = skProduct.priceLocale
        return currencyFormatter.string(from: skProduct.price)
    }
}
