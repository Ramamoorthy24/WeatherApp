//
//  Endpoint.swift

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
}


extension Endpoint {
    // We still have to keep 'url' as an optional, since we're
    // dealing with dynamic components that could be invalid.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "https://api.openweathermap.org/data/2.5"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
    
}

extension Endpoint {
   
   
    static func getTodaysWeather(lat: Double, long: Double) -> Endpoint{
        return Endpoint(path: "\(BaseUrl)/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)", queryItems: [])
    }
    
    static func getDailyForecast(lat: Double, long: Double) -> Endpoint{
        return Endpoint(path: "\(BaseUrl)/forecast?lat=\(lat)&lon=\(long)&&exclude=minutely&appid=\(apiKey)", queryItems: [])
    }
    
}




