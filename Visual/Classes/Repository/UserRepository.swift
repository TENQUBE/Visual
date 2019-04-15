//
//  VisualRepository.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import Foundation

class UserRepository: UserRepo {
    
    let api: VisualApiService
    let udfManager: UserDefaultsManager// local data
    let appExecutor: AppExecutors
   
    init(api: VisualApiService, udfManager: UserDefaultsManager, appExecutor: AppExecutors) {
        self.api = api
        self.udfManager = udfManager
        self.appExecutor = appExecutor
    }
    
    // 가입 여부 체크
    func isSigned(callback: @escaping (_ result: Bool)->()) {
        self.appExecutor.diskIO.async {
            let uid = self.udfManager.pref.string(forKey: Constants.UDFKey.UID)
            self.appExecutor.mainThread.async {
                let isSigned = uid != nil && !uid!.isEmpty
                
                print(isSigned)
                callback(isSigned)
            }
        }
    }
    
    // 사용자 등록 및 기본 정보 등록 프로세스
    func signUp(uid: String, callback: @escaping (_ signUpResult: Constants.SignUpResult)->()) {

        self.api.signUp(uid: uid) { (response: SignUpResponse?, err: Error?) in
            
            self.appExecutor.diskIO.async {
                
                guard let rep = response else {
                    self.appExecutor.mainThread.async {
                        callback(Constants.SignUpResult.fail)
                    }
                     return
                }
                
                print(rep)
       
                self.udfManager.save(key: Constants.UDFKey.SecretKey, value: rep.results.secretKey)
                self.udfManager.save(key: Constants.UDFKey.ResourceUrl, value: rep.results.resource.url)
                self.udfManager.save(key: Constants.UDFKey.ResourceApiKey, value: rep.results.resource.apiKey)
                
                
                self.udfManager.save(key: Constants.UDFKey.SearchUrl, value: rep.results.search.url)
                self.udfManager.save(key: Constants.UDFKey.SearchApiKey, value: rep.results.search.apiKey)
                self.udfManager.save(key: Constants.UDFKey.UID, value: rep.results.authorization.sdk)
                self.udfManager.save(key: Constants.UDFKey.WebUrl, value: rep.results.web.iosUrl)
                
                self.udfManager.save(key: Constants.UDFKey.SignUpTime, value: Date().toMillis())
      
                self.udfManager.synchronize()
                
                self.appExecutor.mainThread.async {
                     callback(Constants.SignUpResult.success)
                }
            }
        }
    }
    
}
