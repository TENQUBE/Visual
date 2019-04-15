//
//
//  Created by tenqube on 2019/02/12.
//  Copyright © 2019 tenqube. All rights reserved.
//

class ResourceApi: ResourceApiService {
 
    private let apiManager: AlamofireManager
    
    init(apiManager: AlamofireManager) {
        self.apiManager = apiManager
    }
    
    func getVersions(callback: @escaping (VersionResponse?, Error?) -> ()) {
        self.apiManager.call(type: ResourceRouter.version) { (response: VersionResponse?, err: Error?) in
            callback(response, err)
        }
    }
    
    func syncCategory(clientVersion: Int, serverVersion: Int, callback: @escaping (ServerCategoryResponse?, Error?) -> ()) {
        self.apiManager.call(type: ResourceRouter.category(clientVersion, serverVersion)) { (response: ServerCategoryResponse?, err: Error?) in
            callback(response, err)
        }
    }
    
    func syncAnalysis(clientVersion: Int, serverVersion: Int, callback: @escaping (AnalysisResponse?, Error?) -> ()) {
        self.apiManager.call(type: ResourceRouter.analysis(clientVersion, serverVersion)) { (response: AnalysisResponse?, err: Error?) in
            callback(response, err)
        }
    }
    
    func syncParsingRule(clientVersion: Int, serverVersion: Int, callback: @escaping (ParserResponse?, Error?) -> ()) {
        self.apiManager.call(type: ResourceRouter.parsingRule(clientVersion, serverVersion)) { (response: ParserResponse?, err: Error?) in
            callback(response, err)
        }
    }
}
