//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
   
    var weatherManger = WeatherManager()
    var searchtext:String = ""
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weatherManger.delegate = self
        searchTextField.delegate = self
    }
    
    
    @IBAction func searchForCurrentWeather(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}
//MARK: - UITextFeildDelegate

extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        searchtext = searchTextField.text ?? "No text here"
        print(searchtext)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text ?? "No text here")
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       guard let city = searchTextField.text else {return }
       weatherManger.fetchWeather(cityName: city)
        searchTextField.text = ""
    }
    
}
//MARK: - PushWeatherModelProtocolDelegate
extension WeatherViewController: PushWeatherModelProtocolDelegate {
    func getWeatherModel(_ weatherManager: WeatherManager, weatherModel: WeatherModel) {
        let weatherconname = weatherModel.conditionName
        print(weatherModel.tempeatureString)
        print (weatherconname)
        DispatchQueue.main.async{
            self.temperatureLabel.text = weatherModel.tempeatureString
            self.conditionImageView.image = UIImage(systemName: weatherconname)
            self.cityLabel.text = weatherModel.cityName
        }
    }
    func didFailWithError(take error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if locations.last != nil{
//            print ("Location available")
//            print("location\(String(describing: locations.last))")
//        }
        
        guard let location = locations.last else { return  }
        locationManager.stopUpdatingLocation()
        print(location)
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManger.fetchWeather(latitude: lat, longitude: lon)
        print(lat)
        print(lon)
        
    print(locations.count)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.requestLocation()
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get users location")
        print(error.localizedDescription)
    }
}
