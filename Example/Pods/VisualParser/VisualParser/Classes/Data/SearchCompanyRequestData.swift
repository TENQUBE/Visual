//
//  SearchCompanyRequestData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

public struct SearchCompanyRequestData {
    public let id: String
    public let keyword: String
    public let at: String
    public let type: String
    public let method: String
    public let amount: Double
    public let amountType: String
    public let lat: Double
    public let long: Double

    public init(_ transaction: TransactionData) {
        var method: String
        if transaction.cardType == 0 {
            method = "debit"
        } else if transaction.cardType == 1 {
            method = "credit"
        } else if transaction.cardType == 2 {
            method = "account"
        } else {
            method = "credit"
        }

        self.id = transaction.identifier
        self.keyword = transaction.keyword
        self.at = transaction.spentDate
        self.type = transaction.dwType == 1 ? "withdraw" : "deposit"
        self.method = method
        self.amount = transaction.spentMoney
        self.amountType = transaction.currency.isEmpty ? "KRW" : transaction.currency
        self.lat = transaction.spentLatitude
        self.long = transaction.spentLongitude
    }

    func toAPIParameters() -> [String: Any] {
        return [
            "id": id,
            "keyword": keyword,
            "at": at,
            "type": type,
            "method": method,
            "amount": amount,
            "amountType": amountType,
            "lat": lat,
            "long": long
        ]
    }
}
