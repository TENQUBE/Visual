//
//  UserDefaultsManager.swift
//  Visual
//
//  Created by tenqube on 18/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation

class UserDefaultsManager {

    let pref: UserDefaults
    
    init(pref: UserDefaults) {
        self.pref = pref
    }

    func clearAll(){
        pref.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        pref.synchronize()
    }
    
    
    func save<T>(key: String, value: T) {
        pref.set(value, forKey: key)
    }
    
    func remove(key: String) {
        pref.removeObject(forKey: key)
    }
 
    func synchronize(){
        let didSave = pref.synchronize()
        if !didSave{
            // Couldn't Save
            print("Preferences could not be saved!")
        }
    }
    
    
}
