//
//  SystemBridge.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import SystemConfiguration

class SystemBridge: BaseBridge, SystemProtocol {
    
    
    func isNetworkConnected() -> Bool {
        
        print("isNetworkConnected")
        return Reachability.isConnectedToNetwork()
    }
    
}
