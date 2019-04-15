//
//  CurrencyResponseData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

public struct CurrencyResponseData {
    public let from: String
    public let to: String
    public let rate: Double

    public init(from: String, to: String, rate: Double) {
        self.from = from
        self.to = to
        self.rate = rate
    }
}
