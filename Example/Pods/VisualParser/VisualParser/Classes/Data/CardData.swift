//
//  CardData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

public struct CardData {
    let id: String
    let name: String
    let num: String
    let type: Int
    let subType: Int
    let balance: Double

    init(_ params: CardParams) {
        name = params.name
        num = params.num
        type = params.type
        subType = params.subType
        balance = params.balance
        id = "\(name)\(num)\(type)\((subType))".replacingOccurrences(of: " ", with: "")
    }
}
