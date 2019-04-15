//
//  TransactionManagerRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

protocol TransactionManagerRepository {
    func findMovedAssets(usedCardId cardId: String,
                         usedCardType cardType: Int,
                         from startDate: Date,
                         to endDate: Date,
                         dwType: Int,
                         money spentMoney: Double) throws -> TransactionManagerData?
    func findAllNotCanceled(usedCardId cardId: String,
                            from startDate: Date,
                            to endDate: Date,
                            money spentMoney: Double,
                            dwType: Int) throws -> [TransactionManagerData]
    func saveAll(_ transactions: [TransactionManagerData])
}
