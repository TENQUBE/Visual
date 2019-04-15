//
//  CardInfo.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
struct CardResponse: Codable {
    let cards: [CardInfo]
    
    init(cards: [CardInfo]) {
        self.cards = cards
    }
}

struct CardInfo: Codable {
    let cardId: Int
    let cardName: String
    let changeName: String
    let changeCardType: Int
    let changeCardSubType: Int
    let cardImgPath: String
    let memo: String
    let totalSum: Double
    let isExcept: Int
    
    init(cardId: Int, cardName: String, changeName: String, changeCardType: Int, changeCardSubType: Int, cardImgPath: String, memo: String, totalSum: Double, isExcept: Int) {
        self.cardId = cardId
        self.cardName = cardName
        self.changeName = changeName
        self.changeCardType = changeCardType
        self.changeCardSubType = changeCardSubType
        self.cardImgPath = cardImgPath
        self.memo = memo
        self.totalSum = totalSum
        self.isExcept = isExcept
        
    }
    
}
