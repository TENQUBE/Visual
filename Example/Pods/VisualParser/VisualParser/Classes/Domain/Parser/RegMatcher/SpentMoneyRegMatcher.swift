//
//  SpentMoneyRegMatcher.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

struct SpentMoneyRegMatcher: RegMatcher {
    let contents: String
    let regExp: String = "\\s*([0-9,])+만원\\s*"

    init(contents: String) {
        self.contents = contents
    }

    func match() -> NSTextCheckingResult? {
        guard let regMatcher = createRegMatcher(with: regExp) else {
            return nil
        }

        let results = match(with: regMatcher, contents)
        return results.isEmpty ? nil : results.first
    }
}
