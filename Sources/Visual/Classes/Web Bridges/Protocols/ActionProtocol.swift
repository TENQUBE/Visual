//
//  ErrorProtocol.swift
//  Visual
//
//  Created by tenqube on 26/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol ActionProtocol: JSExport {
    func requestSmsRecognition(_ params: String)
    
    func reloadSms(_ params: String)
    
    func exportExcel(_ params: String)
    
    func parseSMS(_ callback: String)
    
}
