//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Kiet Nguyen on 5/17/17.
//  Copyright © 2017 Kiet Nguyen. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblVote: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var lblReleaseDate: UILabel!
    var movieID: Int = 0
    var movieDetail: MovieDetail!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        let url = ApiClient.getDetailMovie(movieID: movieID)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: URLRequest(url: url!), completionHandler: {
            data, response, error in
            
            self.onFetchMovieDetailComplete(data, response: response, error: error as NSError?)
        })
        task.resume()
    }
    
    fileprivate func onFetchMovieDetailComplete(_ data: Data?, response: URLResponse?, error: NSError?) {
        if error != nil {
            print("An error occurred while loading detail movie list: \(String(describing: error?.localizedDescription))")
        }
        else {
            if let rawData = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: rawData, options: [])
                    movieDetail = MovieDetail(parsedJson: jsonResponse as! [String : AnyObject])
                    //MARK: - Load data from json
                    DispatchQueue.main.async {
                        self.lblTitle.text = self.movieDetail.titleDetail
                        self.lblOverview.text = self.movieDetail.overviewDetail
                        self.lblVote.text = String(self.movieDetail.voteAverageDetail!)
                        self.lblReleaseDate.text = self.movieDetail.releaseDateDetail
                        //MARK: - Set image
                        let baseUrl = "http://image.tmdb.org/t/p/w500"
                        
                        let imageUrl = URL(string: baseUrl + self.movieDetail.posterPathDetail!)
                        
                        self.imageDetail.sd_setImage(with: imageUrl)
                    }
                    
                }
                catch let error as NSError {
                    // Handle JSON parsing error
                    print("\(error.localizedDescription)")
                }
            }
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

}
