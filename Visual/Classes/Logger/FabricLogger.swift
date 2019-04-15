//
//  FabricLogger.swift
//  Visual
//
//  Created by tenqube on 21/03/2019.
//

import Foundation
//import Crashlytics // If using Answers with Crashlytics


class FabricLogger: Log {
    func sendView(viewName: String) {
       
        // TODO: Move this method and customize the name and parameters to track your key metrics
        //       Use your own string attributes to track common values over time
        //       Use your own number attributes to track median value over time
//        Answers.logCustomEvent(withName: viewName, customAttributes: nil)
    

    }
    
    func sendCustom(withName: String, customAttributes:[String:Any]) {
//          Answers.logCustomEvent(withName: withName, customAttributes: customAttributes)
    }
    
    
}
