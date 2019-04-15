//
//  SpentMoneyExtractor.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/21.
//

struct SpentMoneyExtractor: Extractor {
    let str: String
    let regMatchResult: NSTextCheckingResult

    init(str: String, regMatchResult: NSTextCheckingResult) {
        self.str = str
        self.regMatchResult = regMatchResult
    }

    func extract(position: String = "1") -> String {
        return extract(str: str, regMatchResult: regMatchResult, position: position)
    }
}
