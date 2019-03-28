//
//  StoreKitDelegate.swift
//  InTheClear
//
//  Created by Josh Sauder on 3/27/19.
//  Copyright © 2019 Josh Sauder. All rights reserved.
//

import Foundation
import StoreKit

class StoreKitDelegate: NSObject {
    
    let yearlySubscription = "InTheClear.sub.yearly"
    var products: [String: SKProduct] = [:]
    
    func fetchProducts(){
        let productIDs = Set([yearlySubscription])
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self as! SKProductsRequestDelegate
        request.start()
    }
    
    func purchase(productID: String){
        if let product = products[productID] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
extension StoreKitDelegate: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers.forEach { product in
            print("Invalid: \(product)")
        }
        
        response.products.forEach { product in
            print("Valid: \(product)")
            products[product.productIdentifier] = product
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error for request: \(error.localizedDescription)")
    }
    
}
