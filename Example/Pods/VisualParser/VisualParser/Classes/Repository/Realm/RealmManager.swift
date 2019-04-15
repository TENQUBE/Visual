//
//  RealmManager.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

import RealmSwift

class RealmManager: DbManager {
    private var realm: Realm? = nil

    private func createConn() throws {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: ParserRegRuleVersionModel.className()) { oldObj, newObj in
                        newObj!["updateAt"] = Date()
                    }
                }
        })
        Realm.Configuration.defaultConfiguration = config
        realm = try Realm()
    }

    private func disconnectConn() {
        realm = nil
    }
    
    func beginTransaction() throws {
        try createConn()
        realm!.beginWrite()
    }

    func commit() throws {
        try realm?.commitWrite()
        disconnectConn()
    }

    func rollback() {
        realm?.cancelWrite()
        disconnectConn()
    }

    func saveObject(obj: Object, onDuplicateKeyUpdate: Bool) {
        realm?.add(obj, update: onDuplicateKeyUpdate)
    }

    func getObjects(table: Object.Type) throws -> Results<Object> {
        try createConn()
        return realm!.objects(table)
    }

    func getObjects(table: Object.Type, cond: NSPredicate) throws -> Results<Object> {
        try createConn()
        return realm!.objects(table).filter(cond)
    }
}
