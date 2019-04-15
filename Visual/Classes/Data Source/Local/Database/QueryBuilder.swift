//
//  QueryGenerator.swift
//  Visual
//
//  Created by tenqube on 28/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

class QueryBuilder {
   
    var format: [String] = []
    var args: [Any] = []
    
    func id(id: Int) -> QueryBuilder {
        self.format.append("id = %@")
        self.args.append(id)
        return self
    }
    
    func and() -> QueryBuilder {
        self.format.append("AND")
        return self
    }

    func or() -> QueryBuilder {
        self.format.append("OR")
        return self
    }
    
    func identifiers(identifiers: [Int64]) -> QueryBuilder {
        self.format.append("identifier IN %@")
        self.args.append(identifiers)
        
        return self
    }
    
    func ids(ids: [Int]) -> QueryBuilder {
        self.format.append("id IN %@")
        self.args.append(ids)

        return self
    }
    
    func isExcept(isExcept: Bool) -> QueryBuilder {
        self.format.append("isExcept = %@")
        self.args.append(isExcept)
        return self

    }
    
    func code(code: Int) -> QueryBuilder {
        self.format.append("code = %@")
        self.args.append(code)
        return self
    }
    
    func codes(codes: [Int]) -> QueryBuilder {
        self.format.append("code IN %@")
        self.args.append(codes)
        return self
    }
    
    func cardIds(cardIds: [Int]) -> QueryBuilder {
        self.format.append("cardId IN %@")
        self.args.append(cardIds)
        return self
    }
    
    func userCateIds(userCateIds: [Int]) -> QueryBuilder {
        self.format.append("userCategoryId IN %@")
        self.args.append(userCateIds)
        return self
    }
    
    func isDeleted(isDeleted: Bool) -> QueryBuilder {
        self.format.append("isDeleted = %@")
        self.args.append(isDeleted)
        return self
    }
    
    func isSynced(isSynced: Bool) -> QueryBuilder {
        self.format.append("isSynced = %@")
        self.args.append(isSynced)
        return self
    }

    func date(year: Int, month: Int, before: Int) -> QueryBuilder {
        
        let date = Date.from(year: year, month: month) ?? Date()
        
        print ("date", date)
        
        let toDate = date.getNthMonth(nth: 1) ?? Date()
        let fromDate = date.getNthMonth(nth: -1 * before) ?? Date()
        
        self.format.append("spentDate >= %@ AND spentDate < %@")
        self.args.append(fromDate)
        self.args.append(toDate)
        
        
        print(self.args)
        
        return self
    }

    func keyword(keyword: String) -> QueryBuilder {
        
        self.format.append("keyword = %@")
        self.args.append(keyword)
        return self
    }
    
    func keywords(keywords: [String]) -> QueryBuilder {
        
        self.format.append("keyword IN %@")
        self.args.append(keywords)
   
        return self
    }
    
    func isPopUpCompanyName(flag: Bool) -> QueryBuilder {
        self.format.append("isPopUpCompanyName = %@")
        self.args.append(flag)
        return self
    }
    
    func isUpdateAll(flag: Bool) -> QueryBuilder {
        self.format.append("isUpdateAll = %@")
        self.args.append(flag)
        return self
    }
    
    func dwType(dwType: Int) -> QueryBuilder {
        
        self.format.append("dwType = %@")
        self.args.append(dwType)
        return self
    }
    
    
    func from(from: String) -> QueryBuilder {
    
        self.format.append("from = %@")
        self.args.append(from)
        return self
    }
    
    func to(to: String) -> QueryBuilder {
        self.format.append("to = %@")
        self.args.append(to)
        return self
    }
    
    func fromTo(fromTo: [(String, String)]) -> QueryBuilder {
        
        var values = [String]()
        for value in fromTo {
        
            values.append("(from = %@ and to = %@)")
            self.args.append(value.0)
            self.args.append(value.1)
            
        }
        
        self.format.append(values.joined(separator: " OR " ))
        return self
    }
    
    func nameC(name: String) -> QueryBuilder {
        self.format.append("name CONTAINS %@")
        self.args.append(name)
        return self
    }
    
    func cardName(name: String) -> QueryBuilder {
        self.format.append("name = %@")
        self.args.append(name)
        return self
    }
    
    func cardType(type: Int) -> QueryBuilder {
        self.format.append("type = %@")
        self.args.append(type)
        return self
    }
    
    func cardSubType(subType: Int) -> QueryBuilder {
        self.format.append("subType = %@")
        self.args.append(subType)
        return self
    }
    
    func build() -> NSPredicate {
        
       return NSPredicate(format: format.joined(separator: " "), argumentArray: args)

    }
}
