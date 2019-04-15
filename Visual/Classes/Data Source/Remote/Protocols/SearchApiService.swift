//
//  VisualApiService.swift
//  Visual
//
//  Created by tenqube on 20/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

protocol SearchApiService {
    
    func search(request: SearchCompanyRequest, callback: @escaping (_ response: SearchCompanyResponse, _ error: Error?)->())
}
