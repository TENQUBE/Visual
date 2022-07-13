//
//  VisualApiService.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol VisualApiService {
   
    func signUp(uid: String, callback: @escaping (_ response: SignUpResponse?, _ error: Error?)->())
    
    func getCurrency(from: String, to: String, callback: @escaping (_ response: CurrencyResponse?, _ error: Error?)->())
    
    func saveTransactions(request: TransactionRequest, callback: @escaping (_ response: Bool?, _ error: Error?)->())
    
    func getAds(version: Int, callback: @escaping (_ response: AdResponse?, _ error: Error?)->())
}
