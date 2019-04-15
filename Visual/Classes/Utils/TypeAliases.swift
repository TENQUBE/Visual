//
//  TypeAliases.swift
//  Visual
//
//  Created by tenqube on 25/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

import Foundation

typealias AnalysisParams = (
    id: Int,
    categoryPriority: Int,
    image: String,
    label: String,
    lContent: String,
    mContent: String,
    tranIds: [Int]
)

typealias ContentParams = (
    id: Int,
    priority: Int,
    categoryPriority: Int,
    numOfOccurrence: Int,
    lCode: Int,
    rawKeys: String,
    linkTo: String,
    label: String,
    largeContent: String,
    largeKeys: String,
    mediumContent: String,
    mediumKeys: String,
    image: String
)

typealias ConditionParams = (
    id: Int,
    cId: Int,
    standard: String,
    funcType: String,
    funcKeys: String
)

typealias AdvertisementParams = (
    id: Int,
    title: String,
    label: String,
    content: String,
    linkTo: String,
    linkToType: String,
    linkToStr: String,
    image: String,
    iconImage: String,
    priority: Int,
    query: String
    
)

typealias CardParams = (
    id: Int,
    name: String,
    type: Int,
    subType: Int,
    changeName: String,
    changeType: Int,
    changeSubType: Int,
    billingDay: Int,
    balance: Double,
    memo: String,
    isExcept: Bool,
    isCustom: Bool,
    isDeleted: Bool
)

typealias CategoryParams = (
    id: Int,
    code: Int,
    large: String,
    medium: String,
    small: String
)

typealias CurrencyParams = (
    id: Int,
    from: String,
    to: String,
    rate: Double,
    createdAt: String
)

typealias UserCategoryParams = (
    id: Int,
    code: Int,
    isExcept: Bool
)

typealias BudgetParams = (
    id: Int,
    budget: Int,
    categoryCode: Int,
    date: Date
)

typealias ReportNotificationParams = (
    id: Int,
    name: String,
    title: String,
    content: String,
    ticker: String,
    alarmType: Int,
    dayOfWeek: Int,
    hour: Int,
    day: Int,
    enabled: Bool
    
)


typealias TransactionParams = (
    id: Int,
    identifier: Int64,
    cardId: Int,
    userCategoryId: Int,
    companyId: Int,
    companyName: String,
    companyAddress: String,
    code: Int,
    spentDate: Date,
    finishDate: Date,
    lat: Double,
    lng: Double,
    spentMoney: Double,
    oriSpentMoney: Double,
    installmentCnt: Int,
    keyword: String,
    searchKeyword: String,
    repeatType: Int,
    currency: String,
    isDeleted: Bool,
    dwType: Int,
    smsType: Int,
    fullSms: String?,
    smsDate: Date?,
    
    regId: Int,
    isOffset: Bool,
    isCustom: Bool,
    isUserUpdate: Bool,
    isUpdateAll: Bool,
    memo: String,
    
    classCode: String,
    isSynced: Bool,
    isPopUpCompanyName: Bool
    
)
