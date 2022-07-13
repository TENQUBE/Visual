//
//  CardProtocol.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol CurrencyDataSource {
    
    func find(by from: String, _ to: String) throws ->  Currency?
    
    func find(by fromTo: [(String, String)]) throws ->  [Currency]
    
    func save(_ elements: [Currency]) throws
    
    func removeAll() throws

}
