//
//  SyncRepository.swift
//  Visual
//
//  Created by tenqube on 04/03/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation
import VisualParser

class ResourceRepository: ResourceRepo {
  
    let appExecutor: AppExecutors
    
    let categoryDao: CategoryDataSource
    let userCateDao: UserCategoryDataSource
    
    let currencyDao: CurrencyDataSource
    let advertisementDao: AdvertisementDataSource
    
    let resourceApi: ResourceApiService
    let visualApi: VisualApiService
    let udf: UserDefaultsManager
    let parser: ParserProtocol
    
    init(appExecutor: AppExecutors,
         categoryDao: CategoryDataSource,
         userCateDao: UserCategoryDataSource,
         currencyDao: CurrencyDataSource,
         advertisementDao: AdvertisementDataSource,
         resourceApi: ResourceApiService,
         visualApi: VisualApiService,
         udf: UserDefaultsManager,
         parser: ParserProtocol) {
        
        self.appExecutor = appExecutor
        self.categoryDao = categoryDao
        self.userCateDao = userCateDao
        self.currencyDao = currencyDao
        self.advertisementDao = advertisementDao
        self.resourceApi = resourceApi
        self.visualApi = visualApi
        self.udf = udf
        self.parser = parser
    }
    
    func sync() {
        
        self.appExecutor.networkIO.async {
            self.getVersions { (res) in
                
                guard let res = res else {
                    return
                }
                self.syncParsingRule(serverVersion: res.parsingRule)
                self.syncAnalysis(serverVersion: res.analysis)
                self.syncCategory(serverVersion: res.category)
                self.syncAdvertisement(serverVersion: res.ad)
                
            }
        }
    }
    
    private func getVersions(callback: @escaping (VersionResponse?) -> ()) {
        
        self.resourceApi.getVersions { (res, msg) in
            self.appExecutor.mainThread.async {
                
                callback(res)
            }
        }
    }
    
    // 하루에 한번 환율정보 동기화
    private func syncCurrency() {
        // 요청시간
        // 요청시관과 현재 시간 비교 후 24시간 후인경우
        // 사용자 주로 사용하는 환율 정보 가져오기
        // 해당 환율 요청
        // 업데이트
        // 요청시간 업데이트
        
    }
    
    private func syncParsingRule(serverVersion: Int) {
        appExecutor.diskIO.async {
        
            do {
                var clientVersion = try self.parser.getRuleVersion()
                clientVersion = clientVersion == 0 ? 1 : clientVersion
                
                if clientVersion < serverVersion {
                    
                    self.resourceApi.syncParsingRule(clientVersion: clientVersion, serverVersion: serverVersion, callback: { (res, err) in
                        
                        do {
                            guard let response = res else {
                                return
                            }
                            
                            try self.parser.saveParserData(parserData: response)
                        } catch {
                            
                        }
                    })
                    
                }
            } catch {
                
            }
          
        }
        
    }
    
    private func syncCategory(serverVersion: Int) {
        
        appExecutor.diskIO.async {
            
            // 버전 비교
            var clientVersion = self.udf.pref.integer(forKey: Constants.UDFKey.CategoryVersion)
            clientVersion = clientVersion == 0 ? 11 : clientVersion
            
            if clientVersion < serverVersion {
                self.resourceApi.syncCategory(clientVersion: clientVersion, serverVersion: serverVersion, callback: { (res, error) in
                    
                    guard let response = res, response.categories.count != 0 else {
                        return
                    }
                    
                    do {
                        
                        // 카테고리 삭제
                        let deletedCategories = response.categories.filter{
                            $0.isDeleted  == 1
                        }.map{
                            Category((
                                id: $0.id,
                                code: $0.categoryCode,
                                large: $0.largeCategory,
                                medium: $0.mediumCategory,
                                small: $0.smallCategory
                            ))
                        }
                        
                        try self.categoryDao.remove(deletedCategories)
                        
                        // 기존 카테고리 조회
                        let originCategories = try self.categoryDao.findAll()
                        let categoryDict = Dictionary(uniqueKeysWithValues: originCategories.map{ ($0.code, $0) })
                        
                        // 기존 존재하는 카테고리와 새롭게 추가된 카테고리 분리
                        let categories = response.categories.filter{
                            $0.isDeleted  == 0
                            }.map{
                                Category((
                                    id: $0.id,
                                    code: $0.categoryCode,
                                    large: $0.largeCategory,
                                    medium: $0.mediumCategory,
                                    small: $0.smallCategory
                                    
                                ))
                                
                        }
                        
                        let newCatgories = categories.filter {
                            categoryDict.index(forKey: $0.code) == nil
                        }
                        
                        let updatedCatgories = categories.filter {
                            categoryDict.index(forKey: $0.code) != nil
                        }

                        
                        try self.categoryDao.save(newCatgories)

                        try self.categoryDao.edit(updatedCatgories)
                        
                        self.udf.save(key: Constants.UDFKey.CategoryVersion, value: serverVersion)
                        self.udf.synchronize()

                        
                    } catch {
                        
                    }
                    
                })
            }
        }
    }
    
    private func syncAnalysis(serverVersion: Int) {
        appExecutor.diskIO.async {
            
            // 버전 비교
            var clientVersion = self.udf.pref.integer(forKey: Constants.UDFKey.AnalysisVersion)
            clientVersion = clientVersion == 0 ? 1 : clientVersion
            
            
//            let clientVersion = 0
            if clientVersion < serverVersion {
                // api 요청
                self.resourceApi.syncAnalysis(clientVersion: clientVersion, serverVersion: serverVersion, callback: { (res, error) in
                    // self.analysisDao.
//                    print(res)
                    
                })
                // 응답값 머지
                
                // 버전 업데이트
                self.udf.save(key: Constants.UDFKey.AnalysisVersion, value: serverVersion)
                
                self.udf.synchronize()
            
            }
        }

    }
        

    private func syncAdvertisement(serverVersion: Int) {
        appExecutor.diskIO.async {
            
            // 버전 비교
            var clientVersion = self.udf.pref.integer(forKey: Constants.UDFKey.AdVersion)
            clientVersion = clientVersion == 0 ? 4 : clientVersion
            
             if clientVersion < serverVersion {
                self.visualApi.getAds(version: clientVersion, callback: { (res, error) in
                    
                    do {
                        guard let response = res, response.ads.count != 0 else {
                            return
                        }
                        
                        let originAds = try self.advertisementDao.findAll()
                        
            
                        let adDict = Dictionary(uniqueKeysWithValues: originAds.map{ ($0.id, $0) })
                        
                        let ads = response.ads.map {
                            
                            Advertisement((
                                id:$0.id,
                                title:$0.title,
                                label:$0.label,
                                content:$0.content,
                                linkTo:$0.linkTo,
                                linkToType:$0.linkToType,
                                linkToStr:$0.linkToStr,
                                image:$0.image,
                                iconImage:$0.iconImage,
                                priority:$0.priority,
                                query:$0.query
                                
                            ))
                        }
                        
                        let newAds = ads.filter {
                            adDict.index(forKey: $0.id) == nil
                        }
                        
                        let updatedAds = ads.filter {
                            adDict.index(forKey: $0.id) != nil
                        }
                        
                        try self.advertisementDao.save(newAds)
                        
                        try self.advertisementDao.edit(updatedAds)
                   
                        self.udf.save(key: Constants.UDFKey.AdVersion, value: serverVersion)
                        self.udf.synchronize()
                        
                    } catch {
                        print("error syncAdvertisement")
                    }
                    
                })
            }
        }
    }
    
}
