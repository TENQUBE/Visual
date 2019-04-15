//
//  FullSmsData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/15.
//

fileprivate func transformFullSms(with rawSms: String) -> String {
    var result: String = rawSms

    for replaceChar in ReplaceChar.fullSmsFirst.list {
        result = result.replacingOccurrences(of: replaceChar, with: "")
    }

    for replaceChar in ReplaceChar.fullSmsSecond.list {
        result = result.replacingOccurrences(of: replaceChar, with: " ")
    }

    if !result.isEmpty {
        let toLast = result.index(result.startIndex, offsetBy: 4)
        if String(result[..<toLast]).contains("FW") {
            result = result.replacingOccurrences(of: "FW", with: "")
        }
    }

    return result.trimmingCharacters(in: .whitespaces)
}

public struct FullSmsData {
    let ori: String
    let replaced: String
    let createAt: String = Date().toString()

    init(ori: String) {
        self.ori = ori
        self.replaced = transformFullSms(with: ori)
    }
}
