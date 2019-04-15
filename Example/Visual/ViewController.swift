//
//  ViewController.swift
//  Visual
//
//  Created by kj.sa@tenqube.com on 03/07/2019.
//  Copyright (c) 2019 kj.sa@tenqube.com. All rights reserved.
//

import UIKit
import Visual

class ViewController: UIViewController, VisualViewDelegate {
    
    func onFinish() {
        print("onFinish()")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidLoad")
        do {
            let service = try VisualServiceImpl(apiKey: "LEZQmdU1Zx8hxH1PjfT7hWTzdGOQYre58AVHNgA0", layer: .dev)
            service.startVisual(controller: self, uid: "1234", callback: self)
        } catch {
            print("error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

