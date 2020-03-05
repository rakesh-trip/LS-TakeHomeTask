//
//  NetworkOperation.swift
//  LightSpeedAssignment
//
//  Created by Rakesh Tripathi on 2020-03-03.
//  Copyright © 2020 Rakesh Tripathi. All rights reserved.
//

import Foundation

class NetworkOperation<Decode: Codable> : Operation {
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    // MARK: Private
    let completion: (Decode?, RequestError?) -> Void
    private let baseUrl = "https://swapi.co/api/people"
    private var path: String?
    private var urlComponent: URLComponents?
    private var httpMethod: String?
    private var body: Data?
    
    
    let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpShouldSetCookies = true
        configuration.httpCookieAcceptPolicy = .always
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return URLSession(configuration: configuration)
    }()
    
    // MARK: Initialization
    init(url: String?, method: HTTPMethod, path: String, body: Decode?, completion: @escaping (Decode?, RequestError?) -> Void) {
        
        self.httpMethod = method.rawValue
        self.completion = completion
        self.path = path
        
        if body != nil {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            do {
                self.body = try encoder.encode(body)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // generating url
        var fullPath : String = baseUrl + path
        if url != nil {
            fullPath = url!
        }
        let urlComponents = URLComponents(string: fullPath)
        
        self.urlComponent = urlComponents
        super.init()
        self.name = "Network Operation"
    }
    
    
    // MARK: Override
    override func main() {
        
        var request = URLRequest(url: (self.urlComponent?.url)!)
        request.httpMethod = self.httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = self.body
        
        // Create task
        let task = self.urlSession.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("error while calling the service : \(String(describing: error))")
                self.completion(nil, error as? RequestError)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                self.completion(nil, RequestError(errorType: .NoDataError))
                return
            }
            
            
            let code = (response as! HTTPURLResponse).statusCode
            
            guard code >= 200 && code <= 299 else {
                // Assuming response codes 200 to 299 as success
                do {
                    let decoder = JSONDecoder()
                    let errorObj = try decoder.decode(RequestError.self, from: responseData)
                    self.completion(nil, errorObj)
                } catch {
                    //                    // Parsing Error
                    let errorTemp = RequestError(statusCode: code)
                    self.completion(nil, errorTemp)
                }
                return
            }
            
            // Success
            do {
                
                let decoder = JSONDecoder()
                let parsedJson = try decoder.decode(Decode.self, from: responseData)
                self.completion(parsedJson, error as? RequestError)
            } catch {
                // Parsing Error
                self.completion(nil, error as? RequestError)
            }
        }
        guard self.isCancelled == false else { return }
        task.resume()
    }
}

