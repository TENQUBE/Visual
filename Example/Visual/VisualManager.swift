//
//  VisualManager.swift
//  Visual_Example
//
//  Created by tenqube on 16/04/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//
import Visual

class VisualManager: VisualViewDelegate {
  
    public typealias LayerInfo = (apiKey:String, layer:LayerType)
    
    static let prod: LayerInfo = ("35FfM5fp0A7qloAq9qISm3gbTHJ5LXH726Qpfy5y", LayerType.prod)
    static let dev: LayerInfo = ("LEZQmdU1Zx8hxH1PjfT7hWTzdGOQYre58AVHNgA0", LayerType.dev)
    
    private static var sharedManager: VisualManager = {
        return VisualManager(visualService: createVisual())                                     
    }()
    
    private static func createVisual() -> VisualService? {
        
        var visualService: VisualService?
        
        do {
            //debug -> dev, release -> prod 로 설정해주세요
//            visualService = try VisualServiceImpl(apiKey: dev.apiKey, layer: dev.layer) // 개발
            visualService = try VisualServiceImpl(apiKey: dev.apiKey, layer: dev.layer) // 상용
        } catch {
    
        }
        return visualService;
    }
    
    var visualService: VisualService?
    
    private init(visualService: VisualService?) {
        self.visualService = visualService
    }
    
    public func startVisual(controller: UIViewController, uid: String) {
        guard let visualService = self.visualService else {
            self.visualService = VisualManager.createVisual()
            return
        }
        visualService.startVisual(controller: controller, uid: uid, callback: self)
    
    }
    
    public func signOut() {
        guard let visualService = self.visualService else {
            self.visualService = VisualManager.createVisual()
            return
        }
        visualService.signOut(callback: { (suc) in
            
            print("signOut", suc)
        })
        
    }
    
    // MARK: - Accessors
    
    class func shared() -> VisualManager {
        return sharedManager
    }
    
    func onFinish() {
        print("onFinish")
    }
    
}
