//
//  NetworkManager.swift
//  MovieTime
//
//  Created by Suraj on 25/02/25.
//

import Foundation

enum HTTPMethod:String{
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case CREATE = "CREATE"
    case PUT = "PUT"
}

enum CompletionState{
    case succes
    case failure
    case noInternet
    case notAuthorised
    case noData
}

protocol NetworkServiceProtocol{
    func request(httpMethod:HTTPMethod,endPoint:String,params:[String:String]?,completionHandler: @escaping(_ status:CompletionState, _ data: Data?) -> Void)
}

final class NetworkManager: NetworkServiceProtocol{
    static let shared = NetworkManager()
    private init(){
        
    }
    private let urlSession = URLSession(configuration: .default)
    
    func request(httpMethod:HTTPMethod,endPoint: String, params: [String : String]?, completionHandler: @escaping (CompletionState, Data?) -> Void) {
        switch httpMethod {
        case .GET:
            var urlComponent = URLComponents(string: endPoint)
            var queryItem:[URLQueryItem] = []
            if let params = params {
                for (key,value) in params{
                    queryItem.append(URLQueryItem(name: key, value: value))
                }
            }
            urlComponent?.queryItems = queryItem
            if let url = urlComponent?.url {
                var request = URLRequest(url: url)
                request.httpMethod = httpMethod.rawValue
                let task = urlSession.dataTask(with: request) {data,response,error in
                    if error  == nil {
                        if let data = data {
                            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
                            completionHandler(.succes,data)
                        }
                    } else {
                        if let error = error as? NSError {
                            switch error.code {
                            case NSURLErrorTimedOut, NSURLErrorCannotConnectToHost,
                                NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet:
                                completionHandler(.noInternet,nil)
                            default:
                                completionHandler(.failure,nil)
                            }
                        }
                    }
                }
                task.resume()
            }
            
            
            // we can also implement the other http method ryt now we have use case of GET only so we are implementing GET
        default:
            break
        }
    }
    
}
