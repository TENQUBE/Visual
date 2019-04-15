//
//  Log.swift
//  Visual
//
//  Created by tenqube on 21/03/2019.
//

import Foundation

protocol Log {
    
    func sendView(viewName: String)
    
    func sendCustom(withName: String, customAttributes:[String:Any])
}

enum LogEvent: String {
    case signUp = "signUp"
    case startVisual = "startVisual"
    case visualWebActivity = "VisualWebActivity"
}
