//
//  DbManager.swift
//  VisualParser
//
//  Created by tenqube on 2019/02/22.
//  Copyright © 2019 tenqube. All rights reserved.
//

protocol DbManager {
    func beginTransaction() throws
    func commit() throws
    func rollback()
}
