//
//  CardRepository.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

protocol CardRepository {
    func findBy(id: String) throws -> CardData?
    func findAllBy(type: Int) throws -> [CardData]?
    func updateBalanceAll(_ cards: [CardData])
}
