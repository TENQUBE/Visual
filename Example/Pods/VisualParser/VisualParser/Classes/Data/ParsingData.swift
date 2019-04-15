//
//  ParsingData.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct ParsingData {
    let fullSms: FullSmsData
    let card: CardData
    let transaction: TransactionExtData

    public init(_ fullSms: FullSmsData, _ card: CardData, _ transaction: TransactionExtData) {
        self.fullSms = fullSms
        self.transaction = transaction
        self.card = card
    }
}
