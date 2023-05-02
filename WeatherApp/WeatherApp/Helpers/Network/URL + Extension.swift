//
//  URL + Extension.swift
//

import Foundation

extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        
        self = url
    }
}

extension URLRequest {

    public enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
        case head = "HEAD"
        case options = "OPTIONS"
        case trace = "TRACE"
        case connect = "CONNECT"
    }
    
    public var method: HTTPMethod? {
        get {
            guard let httpMethod = self.httpMethod else { return nil }
            let method = HTTPMethod(rawValue: httpMethod)
            return method
        }
    
        set {
            self.httpMethod = newValue?.rawValue
        }
    }
}

enum PromiseResult<Value> {
    case value(Value)
    case error(Error)
}

class Future<Value> {
    
    fileprivate var result: PromiseResult<Value>? {
        // Observe whenever a result is assigned, and report it
        didSet { result.map(report) }
    }
    private lazy var callbacks = [(PromiseResult<Value>) -> Void]()
    
    func observe(with callback: @escaping (PromiseResult<Value>) -> Void) {
        callbacks.append(callback)
        
        // If a result has already been set, call the callback directly
        result.map(callback)
    }
    
    private func report(result: PromiseResult<Value>) {
        for callback in callbacks {
            callback(result)
        }
    }
}

class Promise<Value>: Future<Value> {
    init(value: Value? = nil) {
        super.init()
        
        // If the value was already known at the time the promise
        // was constructed, we can report the value directly
        result = value.map(PromiseResult.value)
    }
    
    func resolve(with value: Value) {
        result = .value(value)
    }
    
    func reject(with error: Error) {
        result = .error(error)
    }
}

extension URLSession {
    
    func request(url: URLRequest) -> Future<Data> {
        // Start by constructing a Promise, that will later be
        // returned as a Future
        let promise = Promise<Data>()
        
        // Perform a data task, just like normal
        let task = dataTask(with: url) { data, urlResponse, error in
            // Reject or resolve the promise, depending on the result
            if let response = urlResponse as? HTTPURLResponse, response.statusCode != 200 {
                
                let message: String = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                 promise.reject(with: message)
//                if message != "client error" {
//                    if message.lowercased().contains("cancel") {
//                        promise.reject(with: message)
//                    }
//                }
                
            }else {
                if let data = data {
//                    print(String(data: data, encoding: .utf8)!)
                     promise.resolve(with: data)
                }
                else if let response = urlResponse as? HTTPURLResponse, response.statusCode != 200 {
                    let message: String = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
                    promise.reject(with: message)
                }
            }
            
        }
        
        task.resume()
        
        return promise
    }
    
    
}
extension URL {
        var queryParameters: QueryParameters { return QueryParameters(url: self) }
    }

    class QueryParameters {
        let queryItems: [URLQueryItem]
        init(url: URL?) {
            queryItems = URLComponents(string: url?.absoluteString ?? "")?.queryItems ?? []
//            print(queryItems)
        }
        subscript(name: String) -> String? {
            return queryItems.first(where: { $0.name == name })?.value
        }
    }
