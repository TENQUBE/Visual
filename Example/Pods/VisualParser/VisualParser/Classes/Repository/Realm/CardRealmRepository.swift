//
//  CardRealmRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

class CardRealmRepository: RealmRepository, CardRepository {
    func findBy(id: String) throws -> CardData? {
        let whereCond = NSPredicate(format: "id = %@", id)
        guard let obj = try realmManager.getObjects(table: TransactionCardModel.self, cond: whereCond).first,
            let cardModel = obj as? TransactionCardModel else {
                return nil
        }

        return CardData((name: cardModel.name,
                         num: cardModel.num,
                         type: cardModel.type,
                         subType: cardModel.subType,
                         balance: cardModel.balance))
    }

    func findAllBy(type: Int) throws -> [CardData]? {
        var results: [CardData] = []

        let whereCond = NSPredicate(format: "type = \(type)")
        let objects = try realmManager.getObjects(table: TransactionCardModel.self, cond: whereCond)

        for obj in objects {
            if let cardModel = obj as? TransactionCardModel {
                results.append(CardData((name: cardModel.name,
                                         num: cardModel.num,
                                         type: cardModel.type,
                                         subType: cardModel.subType,
                                         balance: cardModel.balance)))
            }
        }

        return results.isEmpty ? nil : results
    }

    func updateBalanceAll(_ cards: [CardData]) {
        for card in cards {
            let cardModel = TransactionCardModel()
            cardModel.id = card.id
            cardModel.name = card.name
            cardModel.num = card.num
            cardModel.type = card.type
            cardModel.subType = card.subType
            cardModel.balance = card.balance

            realmManager.saveObject(obj: cardModel, onDuplicateKeyUpdate: true)
        }
    }
}
