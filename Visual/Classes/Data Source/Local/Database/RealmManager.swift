//
//  RealmManager.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//  @ Reference: https://insights.nimblechapps.com/app-development/ios-app-development/using-realm-mobile-database-with-swift-4-0-insert-update-delete-list
import RealmSwift

class RealmManager {
    
    init() {

        print("RealmManager")
        let config = Realm.Configuration(
            
       
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                
                if (oldSchemaVersion < 1) {
                    print("oldSchemaVersion", oldSchemaVersion)
                

//                    // The enumerateObjects(ofType:_:) method iterates
//                    // over every Person object stored in the Realm file
//                    migration.enumerateObjects(ofType: Person.className()) { oldObject, newObject in
//                        // combine name fields into a single field
//                        let firstName = oldObject!["firstName"] as! String
//                        let lastName = oldObject!["lastName"] as! String
//                        newObject!["fullName"] = "\(firstName) \(lastName)"
//                    }
//
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
    }
    
    // delete table
    func deleteDatabase() throws {
        
        let realm = try Realm()
        
        try realm.write {
           realm.deleteAll()
        }
    }
    
    // delete particular object
    func deleteObject(objs : Object) throws {
    
        let realm = try Realm()
        
        try realm.write {
            realm.delete(objs)
        }
    }
    
    func deleteObject(objs : Results<Object>) throws {
        
        let realm = try Realm()
        
        try realm.write {
            realm.delete(objs)
        }
    }
    
    //Save array of objects to database
    func saveObjects(objs: Object) throws {
    
        let realm = try Realm()
        
        try realm.write {
            // If update = false, adds the object
           realm.add(objs, update: false)
        }
    }
    
    // editing the object
    func editObjects(objs: Object) throws {
        let realm = try Realm()
        
        try realm.write {
            // If update = false, adds the object
            realm.add(objs, update: true)
        }
    }
    
    //Returs an array as Results<object>?
    func getObjects(type: Object.Type) throws -> Results<Object>{
        let realm = try Realm()
        
        return realm.objects(type)
    }

    func incrementID(type: Object.Type) throws -> Int {
        let realm = try Realm()
        
        return (realm.objects(type).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

