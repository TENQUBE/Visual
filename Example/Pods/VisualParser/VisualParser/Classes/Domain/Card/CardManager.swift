//
//  CardManager.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

class CardManager {
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func calBalance(by transactions: [TransactionData]) throws -> [String: CardData] {
        let cards = transactions.reduce([String: CardData](), { (cardDict, transaction) in
            var cards = cardDict

            var balance = transaction.cardBalance
            if balance == 0 {
                let spentMoney = transaction.spentMoney
                let isDeposit = transaction.dwType == DwTypes.deposit.rawValue
                balance = isDeposit ? spentMoney : spentMoney * -1
            }

            if let card = cards[transaction.cardId] {
                balance = card.balance + balance
            }

            cards[transaction.cardId] = CardData((name: transaction.cardName,
                                                  num: transaction.cardNum,
                                                  type: transaction.cardType,
                                                  subType: transaction.cardSubType,
                                                  balance: balance))

            return cards
        })

        var calculatedCards = [String: CardData]()
        for (cardId, card) in cards {
            if let existCard = try repository.card.findBy(id: cardId) {
                calculatedCards[cardId] = CardData((name: existCard.name,
                                                    num: existCard.num,
                                                    type: existCard.type,
                                                    subType: existCard.subType,
                                                    balance: existCard.balance + card.balance))
            } else {
                calculatedCards[cardId] = card
            }
        }

        return calculatedCards
    }

    func saveBalances(_ cardDict: [String: CardData]) throws {
        let cards = cardDict.map({ $1 })

        try repository.dbManager.beginTransaction()
        do {
            repository.card.updateBalanceAll(cards)
            try repository.dbManager.commit()
        } catch {
            repository.dbManager.rollback()
            throw error
        }
    }
}
