//
//  Constants.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

struct Constants {
    enum Separator: String {
        case newLine = "\n"
        case newLineComma = ",\n"
        case comma = ","

    }

    enum SignUpResult: String {
        case success = "Success"
        case fail = "Fail"
    }
    
    
    struct Web {
        static let Version = "1.0.0"
        
        static let External = "external"
        static let Internal = "internal"

    }
    
    struct UDFKey {
        static let ApiKey = "ApiKey"
        static let Layer = "Layer"
       
        static let SecretKey = "SecretKey"
        static let ResourceUrl = "ResourceUrl"
        static let ResourceApiKey = "ResourceApiKey"
        
        
        static let SearchUrl = "SEARCH_URL"
        static let SearchApiKey = "SEARCH_API_KEY"
        static let UID = "UID"
        static let SignUpTime = "SIGN_UP_TIME"
        static let WebUrl = "WEB_URL"
        static let TranPopUp = "TRAN_POPUP"
     
        
        static let CategoryVersion = "CategoryVersion"
        static let AnalysisVersion = "AnalysisVersion"
        static let AdVersion = "AdVersion"
        
        static let VisualData = "VisualData"
        static let AnalysisData = "AnalysisData"
        
        
        
        
        
    }
    
    struct ExceptCode {
        static let Withdraw = 881010
        static let Deposit = 981010
    }
}

enum VisualError: Error {
    case parameter
    case notNull
    case db
}

enum SearchCompany:String {
    
    case deposit = "입금"
    case withdraw = "출금"
    case uncate = "미분류"
    
    var id: Int {
        switch self {
        case .deposit:
            return 3998351
        case .withdraw:
            return 3983436
        default:
            return 1260117
        }
        
    }
    
    var code: Int {
        switch self {
        case .deposit:
            return 901010
        case .withdraw:
            return 841010
        default:
            return 101010
        }
        
    }
    
    var classCode: String {
        switch self {
        case .deposit:
            return "DP"
        case .withdraw:
            return "WFDW"
        default:
            return "NF"
        }
        
        
    }
    
    var title: String {
        switch self {
        case .deposit:
            return "기타"
        case .withdraw:
            return "기타"
        default:
            return "미분류"
        }
        
        
    }
    
}

enum DwType: Int {
    case deposit = 0
    case withdraw = 1
    
    var isExpense: Bool {
        switch self {
        case .deposit:
            return false
        case .withdraw:
            return true
        }
    }
    
    var str: String{
        switch self {
        case .deposit:
            return "deposit"
        case .withdraw:
            return "withdraw"
        }
    }
    
}

enum CardType: Int {
    
    case check = 0
    case credit = 1
    case account = 2
    case cash = 3
    

    var str: String {
        switch self {
        case .check:
            return "0"
        case .credit:
            return "1"
            
        case .account:
            return "2"
            
        default:
            return "3"
        }
    }
    
    var content: String {
        switch self {
        case .check:
            return "체크카드"
        case .credit:
            return "신용카드"
            
        case .account:
            return "계좌"
            
        default:
            return "현금"
        }
    }
    
    var twoStr: String {
        switch self {
        case .check:
            return "체크"
        case .credit:
            return "신용"
            
        case .account:
            return "계좌"
            
        default:
            return "현금"
        }
    }
    
    var search: String {
        switch self {
        case .check:
            return "debit"
        case .credit:
            return "credit"
            
        case .account:
            return "account"
            
        default:
            return "cash"
        }
    }
}
