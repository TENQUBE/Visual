//
//  KeywordRegMatcher.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

struct KeywordRegMatcher: RegMatcher {
    let contents: String
    let regExps: [String] = [
        "\\s*누계\\s*[0-9,-]+[만원]*\\s*(.*)",
        "\\s*누적\\s*[0-9,-]+원*\\s*(.*)",
        "\\s*누적\\s*[0-9,-]+원*\\s*(.*)",
        "\\s*잔액\\s*[0-9,-]+원*\\s*(.*)",
        "\\s*통장잔액\\s*[0-9,-]+원*\\s*(.*)",
        "\\s*지급가능액\\s*[0-9,-]+원*\\s*(.*)",
        "\\s*잔여\\s*[0-9,-]*원+\\s*(.*)",
        "\\s*가능액\\s*[0-9,-]*원+\\s*(.*)",
        "\\s*적립예정\\s*[0-9,-]+원*\\s*(.*)",
        "\\s*잔여한도\\s*[0-9,-]+원*\\s*(.*)",
        "\\s*(.*)\\s+누계.*",
        "\\s*(.*)\\s+누적.*",
        "\\s*(.*)\\s+잔액.*",
        "\\s*(.*)\\s+통장잔액.*",
        "\\s*(.*)\\s+지급가능액.*",
        "\\s*(.*)\\s+잔여.*",
        "\\s*(.*)\\s+가능액.*",
        "\\s*(.*)\\s+적립예정.*",
        "\\s*(.*)\\s+잔여한도.*"
    ]

    init(contents: String) {
        self.contents = contents
    }

    func match() -> NSTextCheckingResult? {
        for (_, regExp) in regExps.enumerated() {
            guard let regMatcher = createRegMatcher(with: regExp) else {
                continue
            }

            let results = match(with: regMatcher, contents)
            if results.isEmpty {
                continue
            }

            return results.first
        }

        return nil
    }
}
