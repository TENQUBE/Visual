//
//  CurrencyRequestData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

public struct CurrencyRequestData {
    public let from: String
    public let to: String

    public init(from: String, to: String = "KRW") {
        self.from = from
        self.to = to
    }
}
