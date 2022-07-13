//
//  ParserAPIData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/26.
//

public struct ParserAPIData {
    let name: String
    let url: String
    let key: String
    let auth: String

    public init(name: String, url: String, key: String, auth: String?) {
        self.name = name
        self.url = url
        self.key = key
        self.auth = auth ?? ""
    }
}
