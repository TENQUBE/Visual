//
//  VisualRepo.swift
//  Visual
//
//  Created by tenqube on 27/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol ParserProtocol {
    
    func getRuleVersion() throws -> Int
    
    func saveParserData(parserData: ParserResponse) throws
    
    func createTransactions(_ fullSmses: [String],
                                   completion: @escaping (Error?, [ParsedTransactionData]) -> Void)

}
