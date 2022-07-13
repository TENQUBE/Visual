//
//  Extractor.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/20.
//

protocol Extractor {
    func extract(str: String, regMatchResult: NSTextCheckingResult, position: String) -> String
}

extension Extractor {
    func extract(str: String, regMatchResult: NSTextCheckingResult, position: String) -> String {
        let isContainComma = position.contains(",")
        let isNumeric = position.isNumeric
        if !isContainComma && !isNumeric {
            return position
        }

        let positions = isContainComma ? position.components(separatedBy: ",") : [position]
        return positions
            .map({ position -> String in
                if !position.isNumeric {
                    return position
                }

                let range = regMatchResult.range(at: Int(position)!)
                return range.length > 0 ? (str as NSString).substring(with: range) : ""
            })
            .joined(separator: "")
    }
}
