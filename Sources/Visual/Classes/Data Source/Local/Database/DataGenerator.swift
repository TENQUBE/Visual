//
//  DataGenerator.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

public enum DataGenerator {
    
    case category
    case currency
    case notification
    case card
    case budget
    case content
    case condition
    

    var filePath: String {
    
        guard let url = Bundle(for: VisualViewController.self).url(forResource: "Visual", withExtension: "bundle"),
              let bundle = Bundle(url: url)
            else {
                return ""
        }
       
        switch self {
        case .category:
            return bundle.path(forResource: "Resource.bundle/categories", ofType: "tsv") ?? ""
        case .currency:
            return bundle.path(forResource: "Resource.bundle/currency", ofType: "tsv")  ?? ""
        case .notification:
            return bundle.path(forResource: "Resource.bundle/notifications", ofType: "tsv")  ?? ""
        case .content:
            return bundle.path(forResource: "Resource.bundle/contents", ofType: "tsv")  ?? ""
        case .condition:
            return bundle.path(forResource: "Resource.bundle/conditions", ofType: "tsv")  ?? ""
        default:
            return ""
        }
    }
    
    var datas: [Any]? {
        
        switch self {
        case .category:
            let contents = try? String(contentsOfFile: filePath, encoding: .utf8)
            
            
            return contents?.parseTSV().map{
                                    Category((id: Int($0[0])!,
                                             code: Int($0[1])!,
                                             large: $0[2],
                                             medium: $0[3],
                                             small: $0[4]))
            }
            
        case .currency:
            var i: Int = 1
            let contents = try? String(contentsOfFile: filePath, encoding: .utf8)
            
            return contents?.parseTSV().map {
                let currency = Currency((id : i,
                                        from: $0[0],
                                        to: $0[1],
                                        rate: Double($0[2])!,
                                        createdAt: $0[3]))

                i = i + 1
                
                
                return currency
            }
            
        case .notification:
            let contents = try? String(contentsOfFile: filePath, encoding: .utf8)
//            id    name    title    content    ticker    alarm_type    day_of_week    hour    day    version    enable    created_at
            return contents?.parseTSV().map {
                ReportNotification((id: Int($0[0])!,
                                    name: $0[1],
                                    title: $0[2],
                                    content: $0[3],
                                    ticker: $0[4],
                                    alarmType: Int($0[5])!,
                                    dayOfWeek: Int($0[6])!,
                                    hour: Int($0[7])!,
                                    day: Int($0[8])!,
                                    enabled: Int($0[10]) == 1))
            }
            
        case .content:
            //id    priority    category_priority    num_of_occurrence    l_code    raw_keys    link_to    label    l_content    l_keys    m_content    m_keys    image

            let contents = try? String(contentsOfFile: filePath, encoding: .utf8)
            return contents?.parseTSV().map {
       
                Content((
                    id: Int($0[0])!,
                    priority: Int($0[1])!,
                    categoryPriority: Int($0[2])!,
                    numOfOccurrence: Int($0[3])!,
                    lCode: Int($0[4])!,
                    rawKeys: $0[5],
                    linkTo: $0[6],
                    label: $0[7],
                    largeContent: $0[8],
                    largeKeys: $0[9],
                    mediumContent: $0[10],
                    mediumKeys: $0[11],
                    image: $0[12]

                ))
            }
            
        case .condition:
            //id    cid    standard    func_type    func_keys
            let contents = try? String(contentsOfFile: filePath, encoding: .utf8)
            return contents?.parseTSV().map {
                
                Condition((
                    id: Int($0[0])!,
                    cId: Int($0[1])!,
                    standard: $0[2],
                    funcType: $0[3],
                    funcKeys: $0[4]
                ))
            }
            
        case .card:
            
            let card = Card((id:1,
                             name: "현금",
                             type: 3,
                             subType: 0,
                             changeName: "현금",
                             changeType: 3,
                             changeSubType: 0,
                             billingDay: 1,
                             balance: 0,
                             memo: "",
                             isExcept: false,
                             isCustom: false,
                             isDeleted: false))
        
            return [card]
            
        case .budget:
         
            let calendar = Calendar.current
            
            var dateComponents: DateComponents? = calendar.dateComponents([.hour, .minute, .second], from: Date())
            
            dateComponents?.day = 1
            dateComponents?.month = 1
            dateComponents?.year = 1900
        
            let date: Date? = calendar.date(from: dateComponents!)
            
            let budget = Budget((id: 1, budget: 1000000, categoryCode: 11, date: date!))
            
            return [budget]
            
 
            
        }
        
    }

}
