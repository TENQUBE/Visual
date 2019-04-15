//
//  Util.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

class Utill {
    
    static func encodeJSON<T:Codable>(obj: T) throws -> String {
        let jsonData = try JSONEncoder().encode(obj)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)!
        return json
    }
    
    static func decodeJSON<T:Codable>(from jsonString: String) throws -> T {
        
        let jsonData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        let mStruct = try decoder.decode(T.self, from: jsonData)
        return mStruct
    }
    
    static func splitCard(cardName: String) -> (String, String) {
        //    롯데(1*2*) -> 롯데,
        
        if let range = cardName.range(of: "(") {
            let name = cardName[cardName.startIndex..<range.lowerBound]
            let num = cardName[range.upperBound..<(cardName.index(cardName.endIndex, offsetBy: -1))]
            return (String(name), String(num))
        } else {
            return (cardName, "")
        }
        
    }
    
    
    
}
