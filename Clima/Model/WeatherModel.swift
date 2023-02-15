//
//  WeatherModel.swift
//  Clima
//
//  Created by Derefaa Cline on 2/10/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var tempeatureString: String{
        let tempString =  String(format:"%.1f",  temperature )
        return tempString
    }
    
    var conditionName:String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snowflake"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
           return "cloud.bolt"
        default:
           return "cloud"
        }
    }
    
    func idImageName(weatherId: Int){
        
    }
    
}
