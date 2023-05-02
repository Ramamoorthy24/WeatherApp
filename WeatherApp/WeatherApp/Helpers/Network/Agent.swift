//
//  Agent.swift


import Foundation
import UIKit
import Photos

struct Agent {

    static func GetData<T: Decodable>(model: T.Type, for endPoint: Endpoint, bodyParam: Any?, httpMethodType: String, headers: [String : String]? = nil) -> Future<T> {
        let promise = Promise<T>()
        let requestFuture =  NetworkService.request(for: endPoint, method: httpMethodType, bodyParameter: bodyParam, headers: headers)
        requestFuture.observe { result in
            switch result {
            case .value(let value):
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(T.self, from: value)
                    promise.resolve(with: decodedData)
                } catch let error {
                    promise.reject(with: "\(error)")
                }
            case .error(let error):
                    promise.reject(with: "\(error)")
                
            }
        }
        return promise
    }
    
    static func GetCancelableData<T: Decodable>(model: T.Type, for endPoint: Endpoint, httpMethodType: String, headers: [String : String]? = nil) -> Future<T> {
        
        let promise = Promise<T>()
        
        let requestFuture =  NetworkService.cancelPreviousRequest(for: endPoint, method: httpMethodType, headers: headers)
        requestFuture.observe { result in
            switch result {
            case .value(let value):
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(T.self, from: value)
                    promise.resolve(with: decodedData)
                } catch let error {
                    promise.reject(with: error.localizedDescription)
                }
            case .error(let error):
                promise.reject(with: "\(error)")
            }
        }
        return promise
    }
    
    
    
}

