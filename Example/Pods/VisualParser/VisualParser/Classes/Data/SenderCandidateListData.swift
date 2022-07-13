//
//  SenderCandidateData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/15.
//

struct SenderCandidateListData {
    let potentialLists: [String]
    let restLists: [String]

    init(potentialLists: [String], restLists: [String]) {
        self.potentialLists = potentialLists
        self.restLists = restLists
    }
}
