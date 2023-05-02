//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Ramamoorthy on 29/04/23.
//

import Foundation
import CoreLocation

class HomeViewModel  {
    
    var weatherData : TodayWeatherData!
    private(set) var dailyForecast : [List]! {
        didSet {
            self.bindDailyForecastToController()
        }
    }
    
    var bindTodayWeatherToController : (() -> ()) = {}
    private(set) var cityName: String = "" {
        didSet {
            self.bindTodayWeatherToController()
        }
    }
    
    var bindDailyForecastToController : (() -> ()) = {}

   
    
    func getTodayWeather(lat: Double, long: Double) {
        let promise = Promise<Bool>()
        
        let requestFuture =
            Agent.GetData(model: TodayWeatherData.self, for: Endpoint.getTodaysWeather(lat: lat, long: long), bodyParam: nil, httpMethodType: "GET")
        requestFuture.observe{result in
                   switch result{
                   case .value(let value):
                       self.weatherData = value
                       self.getCityName(of: CLLocation(latitude: lat, longitude: long))
                       promise.resolve(with: true)
                       break
                   case .error(let error):
                       self.weatherData = nil
                       promise.reject(with: error)
                       break
                   }
               }
    }
    
    func getDailyForecast(lat: Double, long: Double) {
        let promise = Promise<Bool>()
        
        let requestFuture =
            Agent.GetData(model: DailyForecastData.self, for: Endpoint.getDailyForecast(lat: lat, long: long), bodyParam: nil, httpMethodType: "GET")
        requestFuture.observe{result in
                   switch result{
                   case .value(let value):
                       self.dailyForecast = value.list ?? []
                       promise.resolve(with: true)
                       break
                   case .error(let error):
                       self.dailyForecast = []
                       promise.reject(with: error)
                       break
                   }
               }
    }
    
    func getCityName(of location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first {
                var cityName = ""
                if placemark.locality != nil {
                    cityName = "\(placemark.locality ?? ""), \(placemark.country ?? "")"
                }
                if cityName == "" {
                    self.cityName = self.weatherData.name ?? ""
                }else {
                    self.cityName = cityName
                }
            }
        }
    }
    
}
