//
//  SyncRepository.swift
//  Visual
//
//  Created by tenqube on 04/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

class AnalysisRepository: AnalysisRepo {
    
    let appExecutor: AppExecutors
    
    let contentDao: ContentDataSource
    
    let conditionDao: ConditionDataSource
    
    let analysisDao: AnalysisDataSource
    
    let udfManager: UserDefaultsManager
    
    var analysisResults: [AnalysisResult]?
    
    init(appExecutor: AppExecutors,
         contentDao: ContentDataSource,
         conditionDao: ConditionDataSource,
         analysisDao: AnalysisDataSource,
         udfManager: UserDefaultsManager
         ) {
        
        self.appExecutor = appExecutor
        self.contentDao = contentDao
        self.conditionDao = conditionDao
        self.analysisDao = analysisDao
        self.udfManager = udfManager
//        self.resourceApi = resourceApi

    }
    
    func clearCache() {
         self.analysisResults = nil
    }
    
    func generateDatas(callback: @escaping (Bool) -> ()) {
        self.appExecutor.diskIO.async {
            
            do {
                if !self.udfManager.pref.bool(forKey: Constants.UDFKey.AnalysisData) {
                    if let contents = DataGenerator.content.datas {
                        try self.contentDao.removeAll()
                        try self.contentDao.save(contents as! [Content])
                    }
                    
                    if let conditions = DataGenerator.condition.datas {
                        try self.conditionDao.removeAll()
                        try self.conditionDao.save(conditions as! [Condition])
                    }
                    
                    self.udfManager.save(key: Constants.UDFKey.AnalysisData, value: true)
                   
                }
                
                self.appExecutor.mainThread.async {
                    callback(true)
                }
            } catch {
                self.appExecutor.mainThread.async {
                    callback(false)
                }
            }
        }
    }
    
    func loadAnalysisList(req: [JoinedTransaction], callback: @escaping ([AnalysisResult]) -> ()) {
        
        if let analysisResults = self.analysisResults {
            callback(analysisResults)
        } else {
            self.loadFromAnalysis(req: req, callback: callback)
        }
    
    }

//    private func loadFromDB(req: [JoinedTransaction], callback: @escaping ([AnalysisResult]) -> ()) {
//
//    }
    
    private func loadFromAnalysis(req: [JoinedTransaction], callback: @escaping ([AnalysisResult]) -> ()) {
        self.appExecutor.diskIO.async {
     
            var analysies = [Analysis]()
            
            do {
                let contents = try self.contentDao.findAll()
                
                for type in CategoryType.allCases {
                    
                    let filteredContents = contents.filter {
                        
                        switch type {
                        case .monthly, .weekly, .daily:
                            return $0.lCode == type.rawValue
                            
                        default:
                            return $0.lCode == type.rawValue || $0.lCode == 0
                        }
                    }
                    
                    var filteredTransactions = req
                    
                    switch type {
                    case .monthly, .weekly, .daily:
                        break
                    default:
                        filteredTransactions = req.filter {
                            $0.category.getLcode() == String(type.rawValue)
                        }
                        break
                    }
                    
                    if filteredTransactions.count != 0 {
                        analysies.append(AnalysisFactory.create(for: type, contents: filteredContents, transactions: filteredTransactions))
                    }
                }
                
                let result = analysies.flatMap {
                    $0.getContents()
                }
                
                if result.count != 0 {
                    self.analysisResults = result
                }
                
                self.appExecutor.mainThread.async {
                    callback(result)
                }
                
            } catch {
                self.appExecutor.mainThread.async {
                    callback([])
                }
            }
            
        }
    }
    
   
    
}
