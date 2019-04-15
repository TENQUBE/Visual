//
//  SystemBridge.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import UIKit

class UIBridge: BaseBridge, UIProtocol {
    
    var view: UIContractor?
    
    init(webView: WebViewProtocol, view: UIContractor) {
        super.init(webView: webView)
        self.view = view
    }
    
    func openConfirmBox(_ params: String) {
        
        print("openConfirmBox", params)
            
        let request: ConfirmBoxRequest
        
        do {
            request = try Utill.decodeJSON(from: params)
            
            try request.checkParams()
            
            let alert = UIAlertController(title: request.message, message: nil, preferredStyle: UIAlertController.Style.alert)
            
            var index = 0
            var action: UIAlertAction
            
            for element in request.data {
                
                if index == 0 {
                    action = UIAlertAction(title: element.buttonText, style: UIAlertAction.Style.cancel){(_) in
                        super.callback(callback: element.callbackJS, obj: "")
                    }
                    
                } else {
                    action = UIAlertAction(title: element.buttonText, style: UIAlertAction.Style.default){(_) in
                        super.callback(callback: element.callbackJS, obj: "")

                    }
                }
                
                alert.addAction(action)
                index = index + 1
            }
            
            self.view?.show(alert: alert, animated: true, completion: { () in
            
            })
            
        } catch {
            print("param error", params)
        }

    }
    
    func openSelectBox(_ params: String) {
        
        print("openSelectBox", params)
 
        var request: SelectBoxRequest?
        
        do {
            request = try Utill.decodeJSON(from: params)
            try request!.checkParams()
            
            let alert = UIAlertController(title: request!.title, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
            
            for element in request!.data {
                
                let action = UIAlertAction(title: element.name, style: UIAlertAction.Style.default){(action) in
                    
                    // find index return callback
                    print(action.title!)
                   
                    for value in request!.data {
                        if value.name == action.title {
                            super.callback(callback: request!.dataCallbackJS, obj: value)
                            break
                        }
                    }
                }
                
                alert.addAction(action)
                
            }
            
            let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel){(_) in
                
            }
            
            alert.addAction(cancel)
            
            self.view?.show(alert: alert, animated: true, completion: { () in
            })
            
        } catch {
            
            print("openSelectBox error", params)
            guard let callback = request?.dataCallbackJS else {
                return
            }
            super.callback(callback: callback, obj: Success(success: false))
            
        }
    }
    
    func openNewView(_ params: String) {
        
        print("openNewView", params)
        let request: NewViewRequest
        
        do {
            request = try Utill.decodeJSON(from: params)
            try request.checkParams()
            
            if Constants.Web.External == request.viewType {
                guard let url = URL(string: request.url) else { return }
                self.view?.goSafari(url: url)
            }
            
        } catch {
             print("openNewView error", params)
        }
    }
    
    func finish(_ path: String) {
        print("finish", path)
        self.view?.finish()
    }
    
    func showSnackBar(_ msg: String) {

        let alert = UIAlertController(title: msg, message: "", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){(_) in
    
        }
        
        alert.addAction(action)
        
        self.view?.show(alert: alert, animated: false, completion: {
            
        })

    }
    
    func showToast(_ msg: String) {
        print("showToast", msg)
        showSnackBar(msg)
    }
    
    func onPageLoaded(_ params: String) {
        print("onPageLoaded")
        self.view?.onPageLoaded()
    }
    
    func setRefreshEnabled(_ enabled: Bool) {
        print("setRefreshEnabled")
        self.view?.setRefreshEnabled(enabled: enabled)
    }
    
    func onFinish() {
        print("onFinish")
        self.view?.finish()
    }
    
    func showDatePicker(_ params: String) {
        
        print("showDatePicker" + params)
        var request: DateRequest?
        
        do {
            request = try Utill.decodeJSON(from: params)
            try request!.checkParams()
            
            let isoDate = request!.date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from:isoDate) ?? Date()
            
            let datePicker: UIDatePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.locale = Locale.current
            datePicker.date = date
        

            let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
            
            alert.view.addSubview(datePicker)
            
            let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){(_) in
                print(datePicker.date)
                print(dateFormatter.string(from: datePicker.date))
                
                super.callback(callback: request!.callbackJS, obj: dateFormatter.string(from: datePicker.date))
            }
            
            let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel){(_) in
                
            }
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.view?.show(alert: alert, animated: true, completion: { () in
                
                datePicker.frame.size.width = alert.view.frame.size.width
                //                datePicker.center = alert.view.center
                //                alert.view.frame.size.height = datePicker.frame.size.height
            })
        } catch {
            guard let callback = request?.callbackJS else {
                return
            }
            super.callback(callback: callback, obj: Success(success: false))
        }
 
    }
    
    func showTimePicker(_ params: String) {
        print("showTimePicker" + params)

        var request: TimeRequest?
        
        do {
            request = try Utill.decodeJSON(from: params)
            try request!.checkParams()
            
            let isoDate = request!.time
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            let date = dateFormatter.date(from:isoDate) ?? Date()
            
            let datePicker: UIDatePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            datePicker.date = date
            let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertController.Style.alert)
            
            alert.view.addSubview(datePicker)
            
            let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){(_) in
                print(datePicker.date)
                
                super.callback(callback: request!.callbackJS, obj: dateFormatter.string(from: datePicker.date))
            }
            
            let cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel){(_) in
                
            }
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.view?.show(alert: alert, animated: true, completion: { () in
                
                datePicker.frame.size.width = alert.view.frame.size.width
                //                datePicker.center = alert.view.center
                //                alert.view.frame.size.height = datePicker.frame.size.height
            })
        } catch {
            
            guard let callback = request?.callbackJS else {
                return
            }
            super.callback(callback: callback, obj: Success(success: false))
            
        }
    }
    
    func reload() {
        
        print("reload")
        self.view?.reload()

    }
    
    func retry() {
        
        print("retry")
        self.view?.retry()

    }
    
}
