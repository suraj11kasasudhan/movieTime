//
//  MovieService.swift
//  MovieTime
//
//  Created by Suraj on 25/02/25.
//

protocol MovieServiceProtocol{
    func getMovieList(params:[String:String],completionHandler:@escaping(_ status:CompletionState,_ data:Data?) -> Void)
    func getMovieDetail(params:[String:String],completionHandler:@escaping(_ status:CompletionState,_ data:Data?) -> Void)
}

import Foundation

class MovieService: MovieServiceProtocol{
    
    private var networkService:NetworkServiceProtocol?
    
    
    init(networkService:NetworkServiceProtocol = NetworkManager.shared){
        self.networkService = networkService
    }
    
    var movies: [Movie] = []
    var pageNumber:Int = 1
    var movieDetail:MovieDetail?
    var endPagination:Bool = false
    
    func resetData(){
        endPagination = false
        pageNumber = 1
        movies = []
    }
    
    func getMovieList(params:[String:String],completionHandler:@escaping(_ status:CompletionState,_ data:Data?) -> Void) {
        networkService?.request(httpMethod: HTTPMethod.GET, endPoint:AppHelper.moviesEndpoint , params: params){[weak self] status,data in
            guard self != nil else {return}
            switch status {
            case .succes:
                if let data = data , let model = try? JSONDecoder().decode(MovieResponse.self, from: data) {
                    if let search = model.search {
                        self?.movies.append(contentsOf: search)
                        completionHandler(.succes,data)
                    } else {
                        self?.endPagination = true
                        completionHandler(.noData,nil)
                    }
                }
                
            case .failure:
                completionHandler(.failure,nil)
                
            case .noInternet:
                completionHandler(.noInternet,nil)
                
            case .notAuthorised:
                completionHandler(.notAuthorised,nil)
                
            default:
                break
            }
        }
    }
    
    func getMovieDetail(params: [String:String],completionHandler:@escaping(_ status:CompletionState,_ data:Data?) -> Void) {
        networkService?.request(httpMethod: HTTPMethod.GET, endPoint: AppHelper.moviesEndpoint, params: params){[weak self] status,data in
            guard self != nil else { return }
            switch status {
            case .succes:
                if let data = data , let model = try? JSONDecoder().decode(MovieDetail.self, from: data) {
                    self?.movieDetail = model
                    completionHandler(.succes,data)
                }
                completionHandler(.succes,data)
            case .failure:
                completionHandler(.failure,nil)
                
            case .noInternet:
                completionHandler(.noInternet,nil)
                
            case .notAuthorised:
                completionHandler(.notAuthorised,nil)
            default:
                break
            }
        }
        
    }
}


