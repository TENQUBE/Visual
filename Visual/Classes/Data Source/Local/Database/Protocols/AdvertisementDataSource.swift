//
//  CardProtocol.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol AdvertisementDataSource {
   
    func findAll() throws -> [Advertisement]
    
    func save(_ elements: [Advertisement]) throws
    
    func edit(_ elements: [Advertisement]) throws
    
}
