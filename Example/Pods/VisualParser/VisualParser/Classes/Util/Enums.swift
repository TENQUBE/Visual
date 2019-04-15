//
//  Helper.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

enum DefaultRegVersion: Int {
    case id = 1
    case version = -1
}

enum Keyword: String {
    case none = "none"
    case empty = "내용없음"
}

enum ReplaceChar {
    case cardName
    case cardNum
    case cardBalance
    case spentMoney
    case keyword
    case fullSmsFirst
    case fullSmsSecond

    var list: [String] {
        switch self {
        case .cardName:
            return ["카드", "-"]
        case .cardNum:
            return ["(", ")", "-", "X", "#", " "]
        case .cardBalance:
            return [",", " "]
        case .spentMoney:
            return [",", " "]
        case .keyword:
            return ["\t", "<", ">", "////", "  ", "\n"]
        case .fullSmsFirst:
            return [
                "[FW]", "FW>", "듀>", "[재전송]",
                "[투]", "[Web발신]\n", "[Web발신]", "[Web 발신]", "[web 발신]",
                "[web발신]", "[WEB 발신]", "(재전송)"
            ]
        case .fullSmsSecond:
            return ["　", "↵", "[", "]", "\n"]
        }
    }
}

enum CardType: Int {
    case debit = 0, credit, account, cash

    static func convertRawValueFrom(name: String) -> Int {
        switch name {
        case "체크":
            return CardType.debit.rawValue
        case "은행":
            return CardType.account.rawValue
        default:
            return CardType.credit.rawValue
        }
    }
}

enum CardSubType: Int {
    case normal = 0, corporation, family

    static func convertRawValueFrom(name: String) -> Int {
        switch name {
        case "법인":
            return CardSubType.corporation.rawValue
        case "가족":
            return CardSubType.family.rawValue
        default:
            return CardSubType.normal.rawValue
        }
    }
}

enum Currency: String {
    case jpy = "JPY"
    case cny = "CNY"
    case eur = "EUR"
    case usd = "USD"

    static func getCode(by name: String) -> String {
        switch name {
        case "엔":
            return Currency.jpy.rawValue
        case "위안":
            return Currency.cny.rawValue
        case "유로":
            return Currency.eur.rawValue
        case "달러":
            return Currency.usd.rawValue
        default:
            return name
        }
    }
}

enum DwType: Int {
    case deposit = 0, withdraw
}

enum Word: String {
    case depositCandidate
    case keywordRegMatchCandidate
    case cancelCandidate
    case manwon = "만원"
    case defaultParseUserName = "qlip"

    var list: [String] {
        switch self {
        case .depositCandidate:
            return ["입금", "입"]
        case .keywordRegMatchCandidate:
            return ["잔액", "누계", "누적", "가능액", "잔여", "적립예정"]
        case .cancelCandidate:
            return ["취", "취소", "정정"]
        default:
            return []
        }
    }
}

enum DwTypes: Int {
    case deposit = 0, withdraw
}

enum CategoryCode: Int {
    case assetsIn = 981010
    case assetsOut = 881010
    case notFound = 101010
}
