//
//  GeoLocationData.swift
//  VisualParser
//
//  Created by tenqube on 2019/03/25.
//

struct GeoLocationData {
    let lat: Double
    let long: Double

    init(_ lat: Double = -1.0, _ long: Double = -1.0) {
        self.lat = lat
        self.long = long
    }
}
