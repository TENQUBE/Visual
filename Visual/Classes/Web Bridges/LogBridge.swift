//
//  SystemBridge.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation


class LogBridge: BaseBridge, LogProtocol {
    
    var log: Log?
    
    init(webView: WebViewProtocol, log: Log) {
        super.init(webView: webView)
        self.log = log
    }
    
    func onKeyMetric(_ params: String) {
   
        var request: LogRequest?
        
        do {
            request = try Utill.decodeJSON(from: params)
            try request!.checkParams()
            
            self.log?.sendCustom(withName: request!.eventName, customAttributes: request!.toDictionary())
            
        } catch {
            
        }
    }
  
        
}
