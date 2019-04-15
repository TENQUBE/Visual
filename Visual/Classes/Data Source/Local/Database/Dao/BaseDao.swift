//
//  BaseDao.swift
//  Visual
//
//  Created by tenqube on 26/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
public class BaseDao {

    let realmManager: RealmManager
    
    init(manager: RealmManager) {
        realmManager = manager
    }

}
