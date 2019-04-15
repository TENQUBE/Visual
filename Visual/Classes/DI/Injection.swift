//
//  Injection.swift
//  Alamofire
//
//  Created by tenqube on 07/03/2019.
//

import Foundation
import Alamofire
import VisualParser

class Injection {

    var visualRepository: VisualRepo?
    var userRepository: UserRepo?
    var syncTranRepository: SyncTranRepo?
    var resourceRepository: ResourceRepo?
    var analysisRepository: AnalysisRepo?
    var parser: ParserProtocol?
    var logger: Log?
    
    init() {
        let appExecutor = self.provideAppExecutor()
        let dbManager = self.provideDbManager()
        let cardDao = self.provideCardDao(manager: dbManager)
        let adDao = self.provideAdDao(manager: dbManager)
        let cateDao = self.provideCategoryDao(manager: dbManager)
        let currencyDao = self.provideCurrencyDao(manager: dbManager)
        let userCateDao = self.provideUserCateDao(manager: dbManager)
        let tranDao = self.provideTransactionDao(manager: dbManager)
        let contentDao = self.provideContentDao(manager: dbManager)
        let conditionDao = self.provideConditionDao(manager: dbManager)
        let analysisDao = self.provideAnalysisDao(manager: dbManager)
        
        let udfManager = self.provideUserDefaultsManagerDao()
        
        let session = self.provideSession()
        let alamofireManager = self.provideAlamofireManager(session: session)
        let visualApi = self.provideVisualApiService(manager: alamofireManager)
        let searchApi = self.provideSearchApiService(manager: alamofireManager)
        let resourceApi = self.provideResourceApiService(manager: alamofireManager)
        let searchManager = self.provideSearchManager(searchApi: searchApi,
                                                      tranDao: tranDao)
        
        let parserApi = self.provideParserAPI(resourceApi: resourceApi,
                                              searchManager: searchManager,
                                              currencyDao: currencyDao,
                                              appExecutor: appExecutor)
        
        self.parser = self.provideParser(udfManager: udfManager,
                                         appExecutor: appExecutor,
                                         parserApi: parserApi)
        
        // repository
        self.visualRepository = self.provideVisualRepository(udfManager: udfManager,
                                                             searchManager: searchManager,
                                                             visualApi: visualApi,
                                                             cardDao: cardDao,
                                                             adDao: adDao,
                                                             categoryDao: cateDao,
                                                             currencyDao: currencyDao,
                                                             userCateDao: userCateDao,
                                                             tranDao: tranDao,
                                                             appExecutor: appExecutor)
        
        self.userRepository = self.provideUserRepository(api: visualApi,
                                                         udfManager: udfManager,
                                                         appExecutor: appExecutor)
        
        self.syncTranRepository = self.provideSyncTranRepository(appExecutor: appExecutor,
                                                                 categoryDao: cateDao,
                                                                 userCateDao: userCateDao,
                                                                 cardDao: cardDao,
                                                                 tranDao: tranDao,
                                                                 visualApi: visualApi)
        self.resourceRepository = self.provideResourceRepository(appExecutor: appExecutor,
                                                                 categoryDao: cateDao,
                                                                 userCateDao: userCateDao,
                                                                 currencyDao: currencyDao,
                                                                 adDao: adDao,
                                                                 resourceApi: resourceApi,
                                                                 visualApi: visualApi,
                                                                 udf: udfManager, parser: parser!)
        
        self.analysisRepository = self.provideAnalysisRepository(appExecutor: appExecutor,
                                                                 contentDao: contentDao,
                                                                 conditionDao: conditionDao,
                                                                 analysisDao: analysisDao)
        
        // logger
        self.logger = self.provideLogger()
    }
    
    func provideAppExecutor() -> AppExecutors {
        
        return AppExecutors()
    }
    
    func provideDbManager() -> RealmManager {
        return RealmManager()
    }
    
    func provideCardDao(manager: RealmManager) -> CardDataSource {
        return CardDao(manager: manager)
    }
    
    func provideAdDao(manager: RealmManager) -> AdvertisementDataSource {
        return AdvertisementDao(manager: manager)
    }
    
    func provideCategoryDao(manager: RealmManager) -> CategoryDataSource {
        return CategoryDao(manager: manager)
    }
    
    func provideCurrencyDao(manager: RealmManager) -> CurrencyDataSource {
        return CurrencyDao(manager: manager)
    }
    
    func provideUserCateDao(manager: RealmManager) -> UserCategoryDataSource {
        return UserCategoryDao(manager: manager)
    }
    
    func provideTransactionDao(manager: RealmManager) -> TransactionDataSource {
        return TransactionDao(manager: manager)
    }
    
    func provideContentDao(manager: RealmManager) -> ContentDataSource {
        return ContentDao(manager: manager)
    }
    
    func provideConditionDao(manager: RealmManager) -> ConditionDataSource {
        return ConditionDao(manager: manager)
    }
    
    func provideAnalysisDao(manager: RealmManager) -> AnalysisDataSource {
        return AnalysisDao(manager: manager)
    }
    
    func provideUserDefaultsManagerDao() -> UserDefaultsManager {
        return UserDefaultsManager(pref: UserDefaults.standard)
    }
    
    func provideSession()  -> SessionManager {
        return Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    }
    
    func provideAlamofireManager(session: Alamofire.SessionManager)  -> AlamofireManager {
        return AlamofireManager(session: session)
    }
    
    func provideVisualApiService(manager: AlamofireManager) -> VisualApiService {
        return VisualApi(apiManager: manager)
    }
    
    func provideSearchApiService(manager: AlamofireManager) -> SearchApiService {
        return SearchApi(apiManager: manager)
    }
    
    func provideResourceApiService(manager: AlamofireManager) -> ResourceApiService {
        return ResourceApi(apiManager: manager)
    }
    
    func provideParserAPI(resourceApi: ResourceApiService,
                          searchManager: SearchManager,
                          currencyDao: CurrencyDataSource,
                          appExecutor: AppExecutors) -> ParserAPI {
        return ParserApiServiceImpl(resourceApi: resourceApi,
                                    searchManager: searchManager,
                                    currencyDao: currencyDao,
                                    appExecutor: appExecutor)
    }
    
    func provideParser(udfManager: UserDefaultsManager,
                       appExecutor: AppExecutors,
                       parserApi: ParserAPI) -> ParserProtocol {
        return Parser(udfManager: udfManager, appExecutor: appExecutor, parserApi: parserApi)
    }
    
    func provideLogger() -> Log {
        return FabricLogger()
    }
    
    func provideSearchManager(searchApi: SearchApiService, tranDao: TransactionDataSource) -> SearchManager {
        return SearchManager(searchApi: searchApi, transactionDao: tranDao)
    }
    
    func provideVisualRepository(
        udfManager: UserDefaultsManager,
        searchManager: SearchManager,
        visualApi: VisualApiService,
        cardDao: CardDataSource,
        adDao: AdvertisementDataSource,
        categoryDao: CategoryDataSource,
        currencyDao: CurrencyDataSource,
        userCateDao: UserCategoryDataSource,
        tranDao: TransactionDataSource,
        appExecutor: AppExecutors) -> VisualRepo {
        
        return VisualRepository(udfManager: udfManager,
                                searchManager: searchManager,
                                visualApi: visualApi,
                                cardDao: cardDao,
                                adDao: adDao,
                                categoryDao: categoryDao,
                                currencyDao: currencyDao,
                                userCateDao: userCateDao,
                                tranDao: tranDao,
                                appExecutor: appExecutor)
    }
    
    func provideUserRepository(
        api: VisualApiService,
        udfManager: UserDefaultsManager,
        appExecutor: AppExecutors) -> UserRepo {
        
        return UserRepository(
                            api: api,
                            udfManager: udfManager,
                            appExecutor: appExecutor)
    }
    
    func provideResourceRepository(
        appExecutor: AppExecutors,
        categoryDao: CategoryDataSource,
        userCateDao: UserCategoryDataSource,
        currencyDao: CurrencyDataSource,
        adDao: AdvertisementDataSource,
        resourceApi: ResourceApiService,
        visualApi: VisualApiService,
        udf: UserDefaultsManager,
        parser: ParserProtocol) -> ResourceRepo {

        return ResourceRepository(appExecutor: appExecutor,
                                  categoryDao: categoryDao,
                                  userCateDao: userCateDao,
                                  currencyDao: currencyDao,
                                  advertisementDao: adDao,
                                  resourceApi: resourceApi,
                                  visualApi: visualApi,
                                  udf: udf,
                                  parser: parser)

    }
    
    func provideSyncTranRepository(
        appExecutor: AppExecutors,
        categoryDao: CategoryDataSource,
        userCateDao: UserCategoryDataSource,
        
        cardDao: CardDataSource,
        tranDao: TransactionDataSource,
        visualApi: VisualApiService) -> SyncTranRepo {
        
        return SyncTranRepository(appExecutor: appExecutor,
                                  categoryDao: categoryDao,
                                  userCateDao: userCateDao,
                                  
                                  cardDao: cardDao,
                                  tranDao: tranDao,
                                  visualApi: visualApi)
    }
    
    func provideAnalysisRepository(
        appExecutor: AppExecutors,
        contentDao: ContentDataSource,
        conditionDao: ConditionDataSource,
        analysisDao: AnalysisDataSource) -> AnalysisRepo {
        
        return AnalysisRepository(appExecutor: appExecutor,
                                  contentDao: contentDao,
                                  conditionDao: conditionDao,
                                  analysisDao: analysisDao)
    }
    
   
    
}
