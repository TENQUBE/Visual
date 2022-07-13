//
//  AppExecutor.swift
//  Visual
//
//  Created by tenqube on 18/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

class AppExecutors {
    
    let diskIO: DispatchQueue
    let networkIO: DispatchQueue
    let mainThread: DispatchQueue
    
    init() {
        self.diskIO = DispatchQueue(label: "diskIO")
        self.networkIO = DispatchQueue(label: "networkIO")
        self.mainThread = DispatchQueue.main
    }
}
