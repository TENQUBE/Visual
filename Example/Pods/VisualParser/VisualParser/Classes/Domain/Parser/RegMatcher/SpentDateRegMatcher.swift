//
//  SpentDateRegMatcher.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

struct SpentDateRegMatcher: RegMatcher {
    let contents: String
    let regExps: [String] = [
        "\\s*(\\d{1,2})/(\\d{1,2})\\s*,*\\s*(\\d{1,2}):(\\d{1,2})\\s*",
        "\\s*(\\d{1,2})\\.(\\d{1,2})\\s*,*\\s*(\\d{1,2}):(\\d{1,2})\\s*",
        "\\s*(\\d{1,2})월(\\d{1,2})일\\s*(\\d{1,2})시(\\d{1,2})분\\s*",
        "\\s*(\\d{1,2})월(\\d{1,2})일\\s*",
        "\\s*(\\d{1,2})/(\\d{1,2})\\s*",
        "\\s*(\\d{1,2})/(\\d{1,2})\\s*\\s*(\\d{1,2}):(\\d{1,2}):(\\d{1,2})\\s*",
        "\\s*(\\d{4})\\.(\\d{1,2})\\.(\\d{1,2})\\s*(\\d{1,2}):(\\d{1,2}):(\\d{1,2})\\s*",
        "\\s*(\\d{4})/(\\d{1,2})/(\\d{1,2})\\s*(\\d{1,2}):(\\d{1,2})\\s*",
        "\\s*(\\d{4})\\s*-\\s*(\\d{1,2})\\s*-\\s*(\\d{1,2})\\s*",
        "\\s*(\\d{4})년\\s*(\\d{1,2})월\\s*(\\d{1,2})일\\s*",
        "\\s*(\\d{1,2}):(\\d{1,2}):(\\d{1,2})\\s*",
        "\\s*(\\d{1,2})/(\\d{1,2}).(\\d{1,2}):(\\d{1,2})",
        "\\s*(\\d{1,2}):(\\d{1,2})",
        "\\s*(\\d{1,2})/(\\d{1,2}).(\\d{1,2}):(\\d{1,2}):(\\d{1,2})",
        "\\s*(\\d{1,2})월(\\d{1,2})일(\\d{1,2}):(\\d{1,2})",
        "\\s*(\\d{4,4})/(\\d{2,2})/(\\d{2,2})",
        "\\s*(\\d{2,2})-(\\d{2,2})",
    ]

    init(contents: String) {
        self.contents = contents
    }

    func match() -> (NSTextCheckingResult?, Int) {
        for (idx, regExp) in regExps.enumerated() {
            guard let regMatcher = createRegMatcher(with: regExp) else {
                continue
            }

            let results = match(with: regMatcher, contents)
            if results.isEmpty {
                continue
            }

            return (results.first, idx)
        }

        return (nil, -1)
    }
}
