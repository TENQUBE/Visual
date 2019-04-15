//
//  UIProtocol.swift
//  Visual
//
//  Created by tenqube on 26/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol UIProtocol: JSExport {
    
    func openConfirmBox(_ params: String)
    
    func openSelectBox(_ params: String)
    
    func openNewView(_ params: String)
    
    func finish(_ path: String)
    
    func showSnackBar(_ msg: String)
    
    func showToast(_ msg: String)
    
    func onPageLoaded(_ params: String)
    
    func setRefreshEnabled(_ enabled: Bool)
    
    func onFinish()
    
    func showDatePicker(_ callback: String)
    
    func showTimePicker(_ callback: String)
    
    func reload()
    
    func retry()
    
}
