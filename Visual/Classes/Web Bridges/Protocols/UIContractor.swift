//
//  ViewContractor.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import UIKit

protocol UIContractor {
    
    func show(alert: UIAlertController, animated: Bool, completion: @escaping () -> Void)
    
    func onPageLoaded()
    
    func setRefreshEnabled(enabled: Bool)
    
    func finish()
    
    func retry()
    
    func reload()
    
    func addView(view: UIView)
    
    func getView() -> UIView
    
    func goSafari(url: URL)
    
    func goMsgApp()
    
    func export(path: URL)
    
}
