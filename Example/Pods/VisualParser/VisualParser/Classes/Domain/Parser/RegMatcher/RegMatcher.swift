//
//  RegMatcherAble.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/21.
//

protocol RegMatcher {
    func createRegMatcher(with regExp: String) -> NSRegularExpression?
    func match(with regMatcher: NSRegularExpression, _ str: String) -> [NSTextCheckingResult]
}

extension RegMatcher {
    func createRegMatcher(with regExp: String) -> NSRegularExpression? {
        guard let regMatcher = try? NSRegularExpression(pattern: "^\(regExp)$",
            options: [.caseInsensitive,
                      .dotMatchesLineSeparators,
                      .useUnicodeWordBoundaries])
        else { return nil }

        return regMatcher
    }

    func match(with regMatcher: NSRegularExpression, _ str: String) -> [NSTextCheckingResult] {
        let nsStr = str as NSString
        return regMatcher.matches(in: str, range: NSRange(location: 0, length: nsStr.length))
    }
}
