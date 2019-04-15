//
//  VisualService.swift
//  Visual
//
//  Created by tenqube on 03/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import UIKit

public protocol VisualService {

    func startVisual(controller: UIViewController, uid: String, callback: VisualViewDelegate)
    
}
