//
//  SmsRegMatcher.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/21.
//

struct SmsRegMatcher: RegMatcher {
    let contents: String
    let regExp: String

    init(contents: String, regExp: String) {
        self.contents = contents
        self.regExp = regExp
    }

    func match() -> NSTextCheckingResult? {
        guard let regMatcher = createRegMatcher(with: regExp) else {
            return nil
        }

        let results = match(with: regMatcher, contents)
        return results.isEmpty ? nil : results.first
    }
}
