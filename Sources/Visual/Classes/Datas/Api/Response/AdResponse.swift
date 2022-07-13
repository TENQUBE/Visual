//
//  File.swift
//  Visual
//
//  Created by tenqube on 17/02/2019.
//  Copyright © 2019 tenqube. All rights reserved.
//

public struct AdResponse: Codable  {

  
    let ads: [Ad]
    
}

struct Ad: Codable {
    /**
     * 광고 고유 id
     */
    let  id: Int
    
    /**
     * 제목
     */
    let  title: String
    
    /**
     * 라벨 정보
     */
    let  label: String
    
    /**
     * 내용
     */
    let  content: String
    
    /**
     * 연결 url
     */
    let  linkTo: String
    
    /**
     *  마켓, webview, deeplink
     */
    let  linkToType: String
    
    /**
     * 연결 url txt
     */
    let  linkToStr: String
    
    /**
     * 이미지 URL
     */
    let  image: String
    
    /**
     * 이미지 URL
     */
    let  iconImage: String
    
    
    let  priority: Int
    
    let  query: String

}
