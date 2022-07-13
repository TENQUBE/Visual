//
//  VisualRepo.swift
//  Visual
//
//  Created by tenqube on 27/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol UserRepo {
    
    func isSigned(callback: @escaping (_ result: Bool)->())
    
    func signUp(uid: String, callback: @escaping (_ signUpResult: Constants.SignUpResult)->())
    
}
