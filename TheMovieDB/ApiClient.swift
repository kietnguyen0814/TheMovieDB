//
//  ApiClient.swift
//  TheMovieDB
//
//  Created by Kiet Nguyen on 5/17/17.
//  Copyright © 2017 Kiet Nguyen. All rights reserved.
//

import Foundation

class ApiClient {
    static let scheme = "https"
    static let host = "api.themoviedb.org"
    static let apiKeyParam = "api_key"
    static var apiKey: String = "8e3967947a95555f9c430e68d070a0e7"
    
    //move paths
    static let nowPlayingPath = "/now_playing"
    
    //create path for load movies
    class func createUrl(queryParams: [URLQueryItem]?) -> URL? {
        var urlComponent = URLComponents()
        
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = "/3/movie"+nowPlayingPath
        urlComponent.queryItems = [apiKeyQueryParam()]
        
        //add more queryParams
        if let queryParams = queryParams {
            urlComponent.queryItems?.append(contentsOf: queryParams)
        }
        return urlComponent.url
    }
    
    
    //params for apiKey
    class func apiKeyQueryParam() -> URLQueryItem {
        return URLQueryItem(name: apiKeyParam, value: apiKey)
    }
    
    //get detail film
    class func getDetailMovie(movieID: Int) -> URL? {
        var urlComponent = URLComponents()
        
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = "/3/movie/"+String(movieID)
        urlComponent.queryItems = [apiKeyQueryParam()]
        
        return urlComponent.url
    }
}
