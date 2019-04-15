//
//  SpentDateExtractor.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/21.
//

struct SpentDateExtractor: Extractor {
    let str: String
    let regMatchResult: NSTextCheckingResult
    let smsDate: String

    init(str: String, regMatchResult: NSTextCheckingResult, smsDate: String) {
        self.str = str
        self.regMatchResult = regMatchResult
        self.smsDate = smsDate
    }

    func extract(regMatchId: Int) -> String {
        guard let date = smsDate.toDate() else {
            return ""
        }

        var year: String = date.year
        var month: String = date.month
        var day: String = date.day
        var hour: String = date.hour
        var min: String = date.min
        var sec: String = date.sec

        switch regMatchId {
        case 0, 1, 2, 11, 14:
            month = extract(str: str, regMatchResult: regMatchResult, position: "1")
            day = extract(str: str, regMatchResult: regMatchResult, position: "2")
            hour = extract(str: str, regMatchResult: regMatchResult, position: "3")
            min = extract(str: str, regMatchResult: regMatchResult, position: "4")
        case 3, 4:
            month = extract(str: str, regMatchResult: regMatchResult, position: "1")
            day = extract(str: str, regMatchResult: regMatchResult, position: "2")
        case 5, 13:
            month = extract(str: str, regMatchResult: regMatchResult, position: "1")
            day = extract(str: str, regMatchResult: regMatchResult, position: "2")
            hour = extract(str: str, regMatchResult: regMatchResult, position: "3")
            min = extract(str: str, regMatchResult: regMatchResult, position: "4")
            sec = extract(str: str, regMatchResult: regMatchResult, position: "5")
        case 6:
            year = extract(str: str, regMatchResult: regMatchResult, position: "1")
            month = extract(str: str, regMatchResult: regMatchResult, position: "2")
            day = extract(str: str, regMatchResult: regMatchResult, position: "3")
            hour = extract(str: str, regMatchResult: regMatchResult, position: "4")
            min = extract(str: str, regMatchResult: regMatchResult, position: "5")
            sec = extract(str: str, regMatchResult: regMatchResult, position: "6")
        case 7:
            year = extract(str: str, regMatchResult: regMatchResult, position: "1")
            month = extract(str: str, regMatchResult: regMatchResult, position: "2")
            day = extract(str: str, regMatchResult: regMatchResult, position: "3")
            hour = extract(str: str, regMatchResult: regMatchResult, position: "4")
            min = extract(str: str, regMatchResult: regMatchResult, position: "5")
        case 8, 9, 15:
            year = extract(str: str, regMatchResult: regMatchResult, position: "1")
            month = extract(str: str, regMatchResult: regMatchResult, position: "2")
            day = extract(str: str, regMatchResult: regMatchResult, position: "3")
        case 10:
            hour = extract(str: str, regMatchResult: regMatchResult, position: "1")
            min = extract(str: str, regMatchResult: regMatchResult, position: "2")
            sec = extract(str: str, regMatchResult: regMatchResult, position: "3")
        case 12:
            hour = extract(str: str, regMatchResult: regMatchResult, position: "1")
            min = extract(str: str, regMatchResult: regMatchResult, position: "2")
        case 16:
            year = extract(str: str, regMatchResult: regMatchResult, position: "1")
            month = extract(str: str, regMatchResult: regMatchResult, position: "2")
        default:
            break
        }

        return "\(year)-\(month)-\(day) \(hour == "24" ? "00" : hour):\(min):\(sec)"
    }
}
