//
//  WeatherManager.swift
//  Clima
//
//  Created by Derefaa Cline on 2/9/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=2b11319008b508a0eb2c291587c21e5f&units=imperial"
    
    var delegate : PushWeatherModelProtocolDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"

        performRequest(with: urlString)
    }
    func fetchWeather(latitude:CLLocationDegrees, longitude:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"

        performRequest(with: urlString)
    }
    func performRequest(with urlString:String) {
        
        
        guard let url = URL(string:urlString ) else {return}
        
        let session = URLSession(configuration: .default)
           
        let task = session.dataTask(with: url) { ( data, response, error )in
            if error != nil {
                print(error!)
                self.delegate?.didFailWithError(take: error!)
                return
            }
            guard let data = data else {
                print("not getting data back")
             return
            }
            //let dataString = String(data: data, encoding: .utf8)
            guard let weather = self.parseJSON(data) else {return }
            self.delegate?.getWeatherModel(self, weatherModel: weather)
    
    
        }
        
        task.resume()
                
    }
    func parseJSON (_ weatherData: Data) -> WeatherModel?{
        
        
     let decoder = JSONDecoder()
        do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      let id = decodedData.weather[0].id
      let name = decodedData.name
      let temp = decodedData.main.temp
      let weatherModel = WeatherModel(conditionId: id, cityName: name, temperature: temp)
           
      return weatherModel
      
      //print(weatherModel.conditionName)
     // print(weatherModel.tempeatureString)
           }catch{
               delegate?.didFailWithError(take: error)
            print (error)
            
            return nil
        }
    }
    
    
    
    }

protocol PushWeatherModelProtocolDelegate {
    func getWeatherModel(_ weatherManager: WeatherManager, weatherModel: WeatherModel)
    func didFailWithError(take error: Error)
}

