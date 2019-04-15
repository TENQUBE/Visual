//
//  AdvertisementDao.swift
//  Visual
//
//  Created by tenqube on 16/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//
import RealmSwift

public class AnalysisDao: BaseDao, AnalysisDataSource {
    func findAll() throws -> [AnalysisResult] {
        return []
    }
    
    func find(by id: Int) throws -> AnalysisResult? {
        
        return nil
    }
    
    func save(_ elements: [AnalysisResult]) throws {
        
    }
    
    func edit(_ elements: [AnalysisResult]) throws {
        
    }
    
    func removeAll() throws {
        
    }
    

   
    
    
}
