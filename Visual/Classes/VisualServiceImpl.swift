//
//  VisualServiceImpl.swift
//  Visual
//
//  Created by tenqube on 03/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import UIKit

public protocol VisualViewDelegate {
    func onFinish()
}

public enum LayerType:String {
    case dev = "dev"
    case prod = "prod"
}

public class VisualServiceImpl: VisualService {

    let apiKey: String
    let layer: String
    let injector: Injection

    public init(apiKey: String, layer: LayerType) throws {
        self.apiKey = apiKey
        self.layer = layer.rawValue
        self.injector = Injection()
    }
    
    public func startVisual(controller: UIViewController, uid: String, callback: VisualViewDelegate) {
        
        if let visualBundle = getBundle() {
        
            let storyboard = UIStoryboard(name: "Visual", bundle: visualBundle)
            
            guard let vvc = storyboard.instantiateViewController(withIdentifier: "VisualVC") as?
                VisualViewController else {
                    return
            }
            vvc.paramUid = uid
            vvc.paramApiKey = self.apiKey
            vvc.paramLayer = self.layer

            vvc.visualRepository = injector.visualRepository
            vvc.userRepository = injector.userRepository
            vvc.syncTranRepository = injector.syncTranRepository
            vvc.resourceRepository = injector.resourceRepository
            vvc.analysisRepository = injector.analysisRepository
            vvc.parser = injector.parser
            vvc.logger = injector.logger
            vvc.appExecutor = injector.appExecutor
            vvc.visualViewDelegate = callback
            controller.present(vvc, animated: true)
        } else {
            callback.onFinish()
        }
        
    }
    
    func getBundle() -> Bundle? {
        let podBundle = Bundle(for: VisualViewController.self)
        print(podBundle)
        
        guard let bundleURL = podBundle.url(forResource: "Visual", withExtension: "bundle") else {
          
            return nil
        }
        return Bundle(url: bundleURL)
    }
    
    public func signOut(callback: @escaping (Bool) -> ()) {

        injector.visualRepository?.signOut(callback: { (suc) in
            
            callback(suc)
        })

    }
  
  
}
