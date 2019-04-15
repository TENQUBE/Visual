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

    public init(apiKey: String, layer: LayerType) throws {
        self.apiKey = apiKey
        self.layer = layer.rawValue
    }
    
    public func startVisual(controller: UIViewController, uid: String, callback: VisualViewDelegate) {
        
        let storyboard = UIStoryboard(name: "Visual", bundle: nil)
    
        guard let vvc = storyboard.instantiateViewController(withIdentifier: "VisualVC") as?
            VisualViewController else {
            return
        }
        
        vvc.paramUid = uid
        vvc.paramApiKey = self.apiKey
        vvc.paramLayer = self.layer
        
        let injection = Injection()
        
        vvc.visualRepository = injection.visualRepository
        vvc.userRepository = injection.userRepository
        vvc.syncTranRepository = injection.syncTranRepository
        vvc.resourceRepository = injection.resourceRepository
        vvc.analysisRepository = injection.analysisRepository
        vvc.parser = injection.parser
        vvc.logger = injection.logger
        vvc.visualViewDelegate = callback
        controller.present(vvc, animated: true)
        
    }
  
}
