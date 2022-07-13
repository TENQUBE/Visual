//
//  ErrorProtocol.swift
//  Visual
//
//  Created by tenqube on 26/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol ErrorProtocol: JSExport {
    func onError(_ funcName: String, _ msg: String)
}
