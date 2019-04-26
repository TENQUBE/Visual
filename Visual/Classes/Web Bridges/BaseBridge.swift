//
//  SystemBridge.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import WebKit

class BaseBridge: NSObject{

    let webViewProtocol: WebViewProtocol

    init(webView: WebViewProtocol) {
        self.webViewProtocol = webView
    }
    
    func getJs(callback: String, data: String) -> String {
        let value = "'\(data)'"
        return callback + "(" + value + ");"
    }
    
    func callback<T:Codable>(callback: String, obj: T) {
 
        var json = ""
   
        do {
            json = try Utill.encodeJSON(obj: obj)
        } catch {
            json = obj as! String
        }
    
        
        let script = getJs(callback: callback, data: json)
        //            self.webView.ja
        print(script)
        
        execute(script: script)
       
    }
    
    func execute(script: String) {
        self.webViewProtocol.executeJs(js: script)
        
    }
    
}
