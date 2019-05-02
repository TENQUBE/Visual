//
//  CategoryType.swift
//  Visual
//
//  Created by tenqube on 20/03/2019.
//

import Foundation
public enum CategoryType: Int,CaseIterable {
    case monthly = 11
    case weekly = 2
    case daily = 1
    case food = 22
    case cafe = 24
    case alcohol = 26
    case mart = 32
    case online = 34
    case department = 36
    case finance = 42
    case health = 44
    
    case beauty = 46
    case home = 52
    case education = 54
    case culture = 56
    
    case transport = 62
    case sports = 64
    case travel = 66
    case family = 82
    case withdraw = 84
    case movingAsset = 88
    
    var imgs: [String] {
        switch self {
        case .food:
            return [
                "lv0_food_else_1",
                "lv0_mid_food_chinese",
                "lv0_mid_food_dining_place",
                "lv0_mid_food_fam_re",
                "lv0_mid_food_fastfood_1",
                "lv0_mid_food_gogi",
                "lv0_mid_food_japanese",
                "lv0_mid_food_korean",
                "lv0_mid_food_late_night",
                "lv0_mid_food_western",
                "lv0_mid_chicken"
                
            ]
        case .cafe:
            return [
                "lv0_cafe_else_1",
                "lv0_mid_cafe_bakery",
                "lv0_mid_cafe_coffee",
                "lv0_mid_cafe_dessert",
                "lv0_mid_cafe_donut"
                
            ]
        case .alcohol:
            return [
                "lv0_alcohol_else",
                "lv0_alcohol_soolzip_yesterday",
                
                "lv0_mid_alcohol_soolzip",
                "lv0_mid_alcohol_entertainment"
                
            ]
        case .mart:
            return [
                "lv0_mart_else",
                "lv0_mid_mart_grocery",
                "lv0_mid_mart_conveni",
                "lv0_mid_mart_dailyitems",
                "lv0_mid_mart_events_flower",
                "lv0_mid_mart_housework",
                "lv0_mid_mart_kids_1",
                "lv0_mid_mart_pets"
                
            ]
        case .online:
            return [
                "lv0_online_else",
                "lv0_mid_online_homeshop"
                
            ]
        case .department:
            return [
                "lv0_shopping_else",
                "lv0_mid_shopping_sportbrand"
            ]
        case .finance:
            return [
                "lv0_finance_else",
                "lv0_mid_finance_insurance",
                "lv0_mid_finance_tax"
                
            ]
        case .health:
            return [
                "lv0_healthcare_else",
                "lv0_mid_healthcare_clinic",
                "lv0_mid_healthcare_dentist",
                "lv0_mid_healthcare_healthproduct",
                "lv0_mid_healthcare_pharmacy"
            ]
            
        case .beauty:
            return [
                "lv0_beauty_else_1",
                "lv0_mid_beauty_nail",
                "lv0_mid_beauty_hairshop",
                "lv0_mid_beauty_makeup",
                "lv0_mid_beauty_skin"
            ]
        case .home:
            return [
                "lv0_livings_else",
                "lv0_mid_livings_telecom"
                
            ]
        case .education:
            return [
                "lv0_education_else",
                "lv0_mid_education_academy",
                "lv0_mid_education_school"
            ]
        case .culture:
            return [
                "lv0_culture_else",
                "lv0_mid_culture_movies",
                "lv0_mid_culture_books",
                "lv0_mid_culture_hobby"
            ]
            
        case .transport:
            return [
                "lv0_transportation_else",
                "lv0_mid_transportation_gas",
                "lv0_mid_transportation_taxi",
                "lv0_mid_transportation_car",
                "lv0_mid_transportation_masstransit"
            ]
        case .sports:
            return [
                "lv0_leports_else"]
        case .travel:
            return [
                "lv0_travel_else",
                "lv0_mid_travel_sightseeing",
                "lv0_mid_travel_hotel"
            ]
        case .family:
            return [
                "lv0_family_event_else"]
            
        default:
            return ["lv0_uncate_else"]
        }
    }

}
