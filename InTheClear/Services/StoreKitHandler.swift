//
//  StoreKitHandler.swift
//  InTheClear
//
//  Created by Josh Sauder on 11/8/21.
//  Copyright © 2021 Josh Sauder. All rights reserved.
//

import Foundation
import StoreKit

class StoreKitHandler: NSObject {
    
    let productIdentifiers: Set<String>
    let currencyFormatter: NumberFormatter = NumberFormatter()
    var skProducts: Dictionary<String, SKProduct> = [:]
    let YEARLY = "yearly"
    var productDidPurchased: (() -> Void)?
    
    override init() {
        productIdentifiers = Set<String>([YEARLY])
        currencyFormatter.numberStyle = .currency
        super.init()
        SKPaymentQueue.default().add(self)
        getAppStoreProducts()
    }
    
    /**
     Fetches Apps In App purchases
     */
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
    /**
     Sends purchase to the Store Kit Payment Queue
     - parameters:
        - product: Product ID
     */
    func purchase(product: String){
        guard let skProduct = skProducts[product] else { return }
        SKPaymentQueue.default().add(SKPayment(product: skProduct))
    }
    
    /**
     Restores previous purchases
     */
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
                break
            case .purchased:
                print("Purchased: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
                productDidPurchased?()
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
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
    /**
     Fetches price for a given product
     - parameters:
        - productKey: The product identifier
     - returns: Product price
     */
    private func price(forProduct productKey: String) -> String? {
        let currencyFormatter = NumberFormatter()
        guard let skProduct = skProducts[productKey] else { return nil }
        currencyFormatter.locale = skProduct.priceLocale
        return currencyFormatter.string(from: skProduct.price)
    }
}
