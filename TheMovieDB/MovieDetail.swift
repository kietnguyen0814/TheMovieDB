//
//  MovieDetail.swift
//  TheMovieDB
//
//  Created by Kiet Nguyen on 5/17/17.
//  Copyright © 2017 Kiet Nguyen. All rights reserved.
//

import Foundation
class MovieDetail {
    static let moviesPath = "/3/movie"
    
    var overviewDetail: String?
    var titleDetail: String?
    var posterPathDetail: String?
    var voteAverageDetail: Double?
    var releaseDateDetail: String?
    var idDetail: Int?
    
    //MARK: - init and parse data
    init(parsedJson: [String: AnyObject]) {
        if let overview = parsedJson["overview"] as? String {
            self.overviewDetail = overview
        }
        
        if let posterPath = parsedJson["poster_path"] as? String {
            self.posterPathDetail = posterPath
        }
        
        if let title = parsedJson["title"] as? String {
            self.titleDetail = title
        }
        
        if let voteAverage = parsedJson["vote_average"] as? Double {
            self.voteAverageDetail = voteAverage
        }
        
        if let releaseDate = parsedJson["release_date"] as? String{
            self.releaseDateDetail = releaseDate
        }
        
        if let id = parsedJson["id"] as? Int {
            self.idDetail = id;
        }
    }
}
