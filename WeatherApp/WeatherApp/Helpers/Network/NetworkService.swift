//

import Foundation
import UIKit

class NetworkService {
    
    static var dataTask: URLSessionDataTask?
    static let defaultSession = URLSession(configuration: .default)
    
    static func request(for endpoint: Endpoint, method: String, bodyParameter: Any? = nil, headers: [String : String]? = nil) -> Future<Data> {
        
        let promise = Promise<Data>()
        guard let url = URL(string: endpoint.path) else{//endpoint.url else {
            promise.reject(with: "Invalid URL")
            return promise
        }
        

        var urlRequest = URLRequest(url: url)
        if let parameter = bodyParameter {
            do {
                if parameter is Dictionary<String, Any> {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
                } else if parameter is Data {
                    urlRequest.httpBody = (parameter as! Data)
                }
                
            } catch let error {
                promise.reject(with: error)
                return promise
            }
        }
        urlRequest.httpMethod = method
        if let header = headers {
            urlRequest.allHTTPHeaderFields = header
        } else {
             urlRequest.allHTTPHeaderFields = ["contentType": "application/json"]
        }
        return URLSession.shared.request(url: urlRequest)
    }
    
    static func cancelPreviousRequest(for endpoint: Endpoint, method: String, headers: [String : String]?=nil) -> Future<Data> {
        
        let promise = Promise<Data>()
        dataTask?.cancel()
        
        guard let url = endpoint.url else {
            promise.reject(with: "Invalid URL")
            return promise
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.allHTTPHeaderFields = headers ?? [:]
        
        dataTask = defaultSession.dataTask(with: urlRequest) { data, urlResponse, error in
            defer { self.dataTask = nil }
            if let error = error as NSError?, error.code != NSURLErrorCancelled {
                promise.reject(with: error)
            }
            
            if let response = urlResponse as? HTTPURLResponse, response.statusCode != 200 {
                
                let message: String = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                 promise.reject(with: message)
//                if message != "client error" {
//                    if message.lowercased().contains("cancel") {
//                        promise.reject(with: message)
//                    }
//                }
                
            } else if let data = data {
                promise.resolve(with: data)
            }
        }
        
        dataTask?.resume()
        return promise
    }
    
   

}

