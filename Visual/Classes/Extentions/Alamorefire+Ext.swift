//
//  Alamorefire+Ext.swift
//  Visual
//
//  Created by tenqube on 27/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import Alamofire

extension Request {
    public func debugLog() -> Self {
        print(self)
        return self
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
