//
//  ParserDefaultManager.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/21.
//

import CryptoSwift
import SwiftyJSON

class ParserDefaultDataManager {
    private let repository: Repository
    private let bundle: Bundle
    private let secretKey: String

    private enum ParserDefaultDataManagerError: Error {
        case canNotInitParserDefaultDataManager
        case canNotLoadData(name: String)
    }

    init(repository: Repository, secretKey: String) throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "VisualParser",
                                                        withExtension: "bundle"),
            let bundle = Bundle(url: url)
        else {
            throw ParserDefaultDataManagerError.canNotInitParserDefaultDataManager
        }

        self.bundle = bundle
        self.repository = repository
        self.secretKey = secretKey
    }

    private func getFileData(resourceName: String, fileType: String = "txt") throws -> JSON {
        guard let path = bundle.path(forResource: resourceName, ofType: fileType)
        else { throw ParserDefaultDataManagerError.canNotLoadData(name: resourceName) }

        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        let iv = [UInt8](repeating: 0, count: 16)
        let aes = try AES(key: secretKey.bytes, blockMode: CBC(iv: iv), padding: .pkcs7)

        let strResult = String(decoding: data, as: UTF8.self)
        let result = try strResult.decryptBase64ToString(cipher: aes)
        let json = JSON(parseJSON: result)

        return json
    }

    private func isRegRuleVersionEmpty() throws -> Bool {
        let results = try repository.regRuleVersion.findCurrentVersion()
        return results == nil
    }

    private func isSenderEmpty() -> Bool {
        do {
            let results = try repository.sender.findAll()
            return results.isEmpty
        } catch {
            return false
        }
    }

    private func isRegRuleEmpty() -> Bool {
        do {
            let results = try repository.regRule.findAll()
            return results.isEmpty
        } catch {
            return false
        }
    }

    private func isRepSenderNameEmpty() -> Bool {
        do {
            let results = try repository.repSenderName.findAll()
            return results.isEmpty
        } catch {
            return false
        }
    }

    private func getDefaultRegRules() throws -> [RegRuleData] {
        let json = try getFileData(resourceName: "RegRule")
        return ParserRawDataProcessor.transformRegRules(from: json["data"])
    }

    private func getDefaultRegRuleVersion() throws -> Int {
        let json = try getFileData(resourceName: "RegVersion")
        let regVersion = ParserRawDataProcessor.transformRegRuleVersion(from: json["version"])

        return regVersion ?? DefaultRegVersion.version.rawValue
    }

    private func getDefaultSenders() throws -> [SenderData] {
        let json = try getFileData(resourceName: "Sender")
        return ParserRawDataProcessor.transformSenders(from: json["data"])
    }

    private func getDefaultRepSenderNames() throws -> [RepSenderNameData] {
        let json = try getFileData(resourceName: "RepSenderName")
        return ParserRawDataProcessor.transformRepSenderNames(from: json["data"])
    }

    func getData() throws -> ParserData? {
        let isRegRuleNotExist = isRegRuleEmpty()
        let isSenderNotExist = isSenderEmpty()
        let isRegRuleVersionNotExist = try isRegRuleVersionEmpty()
        let isRepSenderNameNotExist = isRepSenderNameEmpty()
        let shouldSaveDefaultData = isRegRuleNotExist || isSenderNotExist
            || isRegRuleVersionNotExist || isRepSenderNameNotExist

        if !shouldSaveDefaultData {
            return nil
        }

        let defaultRegRuleVersion = isRegRuleVersionNotExist
            ? try getDefaultRegRuleVersion()
            : DefaultRegVersion.version.rawValue
        let defaultRegRules = isRegRuleNotExist ? try getDefaultRegRules() : []
        let defaultSenders = isSenderNotExist ? try getDefaultSenders() : []
        let defaultRepSenderNames = isRepSenderNameNotExist ? try getDefaultRepSenderNames() : []

        return ParserData(regRuleVersion: defaultRegRuleVersion,
                          regRules: defaultRegRules,
                          senders: defaultSenders,
                          repSenderNames: defaultRepSenderNames)
    }
}
