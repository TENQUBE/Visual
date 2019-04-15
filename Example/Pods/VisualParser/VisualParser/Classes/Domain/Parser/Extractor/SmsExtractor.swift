//
//  SmsExtractor.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/21.
//

struct SmsExtractor: Extractor {
    let str: String
    let regMatchResult: NSTextCheckingResult

    init(str: String, regMatchResult: NSTextCheckingResult) {
        self.str = str
        self.regMatchResult = regMatchResult
    }

    func extract(position: String) -> String {
        let result = extract(str: str, regMatchResult: regMatchResult, position: position)
        return result.replacingOccurrences(of: " ", with: "")
    }
}
