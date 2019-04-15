//
//  VisualBridge.swift
//  Visual
//
//  Created by tenqube on 19/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol LogProtocol: JSExport {
    func onKeyMetric(_ params: String)
}
