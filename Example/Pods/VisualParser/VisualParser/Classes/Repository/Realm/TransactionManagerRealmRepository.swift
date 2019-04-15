//
//  TransactionManagerRealmRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

class TransactionManagerRealmRepository: RealmRepository, TransactionManagerRepository {
    func findMovedAssets(usedCardId cardId: String,
                         usedCardType cardType: Int,
                         from startDate: Date,
                         to endDate: Date,
                         dwType: Int,
                         money spentMoney: Double) throws -> TransactionManagerData? {
        var query = "cardId != %@"
        query += " AND cardType = \(cardType)"
        query += " AND spentMoney = \(spentMoney)"
        query += " AND dwType != \(dwType)"
        for exceptCategoryCode in [CategoryCode.assetsIn.rawValue, CategoryCode.assetsOut.rawValue] {
            query += " AND categoryCode != \(exceptCategoryCode)"
        }
        query += " AND spentDate > %@ AND spentDate <= %@"
        let whereCond = NSPredicate(format: query, cardId, startDate as NSDate, endDate as NSDate)

        guard let obj = try realmManager.getObjects(table: TransactionManagerModel.self, cond: whereCond).first,
            let tranManagerModel = obj as? TransactionManagerModel else {
                return nil
        }

        return TransactionManagerData((identifier: tranManagerModel.identifier,
                                       cardId: tranManagerModel.cardId,
                                       cardType: tranManagerModel.cardType,
                                       spentMoney: tranManagerModel.spentMoney,
                                       spentDate: tranManagerModel.spentDate.toString(),
                                       installmentCount: tranManagerModel.installmentCount,
                                       keyword: tranManagerModel.keyword,
                                       dwType: tranManagerModel.dwType,
                                       isCancel: tranManagerModel.isCancel,
                                       categoryCode: tranManagerModel.categoryCode))
    }

    func findAllNotCanceled(usedCardId cardId: String,
                            from startDate: Date,
                            to endDate: Date,
                            money spentMoney: Double,
                            dwType: Int) throws -> [TransactionManagerData] {
        var results: [TransactionManagerData] = []

        var query = "cardId = %@"
        query += " AND dwType = \(dwType)"
        query += " AND isCancel = 0 AND spentMoney = \(spentMoney)"
        query += " AND spentDate > %@ AND spentDate <= %@"
        let whereCond = NSPredicate(format: query, cardId, startDate as NSDate, endDate as NSDate)
        let objects = try realmManager.getObjects(table: TransactionManagerModel.self, cond: whereCond)

        for obj in objects {
            if let tranManagerModel = obj as? TransactionManagerModel {
                results.append(TransactionManagerData((identifier: tranManagerModel.identifier,
                                                       cardId: tranManagerModel.cardId,
                                                       cardType: tranManagerModel.cardType,
                                                       spentMoney: tranManagerModel.spentMoney,
                                                       spentDate: tranManagerModel.spentDate.toString(),
                                                       installmentCount: tranManagerModel.installmentCount,
                                                       keyword: tranManagerModel.keyword,
                                                       dwType: tranManagerModel.dwType,
                                                       isCancel: tranManagerModel.isCancel,
                                                       categoryCode: tranManagerModel.categoryCode)))
            }
        }

        return results
    }

    func saveAll(_ transactions: [TransactionManagerData]) {
        for transaction in transactions {
            let tranManagerModel = TransactionManagerModel()
            tranManagerModel.identifier = transaction.identifier
            tranManagerModel.cardId = transaction.cardId
            tranManagerModel.cardType = transaction.cardType
            tranManagerModel.spentMoney = transaction.spentMoney
            tranManagerModel.spentDate = transaction.spentDate as NSDate
            tranManagerModel.installmentCount = transaction.installmentCount
            tranManagerModel.keyword = transaction.keyword
            tranManagerModel.dwType = transaction.dwType
            tranManagerModel.isCancel = transaction.isCancel
            tranManagerModel.categoryCode = transaction.categoryCode

            realmManager.saveObject(obj: tranManagerModel, onDuplicateKeyUpdate: true)
        }
    }
}
