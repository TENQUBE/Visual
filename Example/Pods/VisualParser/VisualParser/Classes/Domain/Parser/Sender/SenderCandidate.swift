//
//  Candidate.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/15.
//

struct SenderCandidate {
    let repSenderNameDict: RepSenderNameDict
    let repSenderNames: [String]

    init(repSenderNameDict: RepSenderNameDict) {
        self.repSenderNameDict = repSenderNameDict
        self.repSenderNames = Array(repSenderNameDict.keys)
    }

    func findCandidateLists(by fullSmsData: FullSmsData) -> SenderCandidateListData {
        var potentialLists: [String] = []
        var restLists: [String] = []

        for (repSenderName, senderNames) in repSenderNameDict {
            for senderName in senderNames {
                if fullSmsData.replaced.contains(senderName) {
                    potentialLists.append(repSenderName)
                }
            }
        }

        if potentialLists.isEmpty {
            restLists = repSenderNames
        } else {
            restLists = repSenderNames.filter({ !potentialLists.contains($0) })
        }

        return SenderCandidateListData(potentialLists: potentialLists, restLists: restLists)
    }
}
