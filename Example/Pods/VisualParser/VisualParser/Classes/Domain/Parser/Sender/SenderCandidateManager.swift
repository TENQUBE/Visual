//
//  CandidateManager.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/15.
//

class SenderCandidateManager {
    let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func createSenderCandidate() throws -> SenderCandidate {
        let repSenderNames = try repository.repSenderName.findAllNotDeleted()

        var repSenderNameDict = RepSenderNameDict()
        for repSenderName in repSenderNames {
            if var senders: [String] = repSenderNameDict[repSenderName.repSender] {
                senders.append(repSenderName.sender)
                repSenderNameDict[repSenderName.repSender] = senders
            } else {
                repSenderNameDict[repSenderName.repSender] = [repSenderName.sender]
            }
        }

        return SenderCandidate(repSenderNameDict: repSenderNameDict)
    }
}


