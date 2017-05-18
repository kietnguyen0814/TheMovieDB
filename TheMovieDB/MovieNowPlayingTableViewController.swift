//
//  MovieNowPlayingTableViewController.swift
//  TheMovieDB
//
//  Created by Kiet Nguyen on 5/17/17.
//  Copyright © 2017 Kiet Nguyen. All rights reserved.
//

import UIKit

enum selectedScope:Int {
    case title = 0
    case vote = 1
}
class MovieNowPlayingTableViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    var initialMovie = [Movie]()
    var moviePath: String?
    var page: Int?
    var nowPlayingMovie = [Movie]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        getMovies(page: 1)
        self.searchBarSetup()
    }

    func searchBarSetup() {
        searchBar.showsScopeBar = true
        //searchBar.scopeButtonTitles = ["Title"]
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar
    }
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
        if searchText.isEmpty {
            nowPlayingMovie = initialMovie
            self.tableView.reloadData()
        }else {
            filterTableView(ind: searchBar.selectedScopeButtonIndex, text: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        nowPlayingMovie = initialMovie
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func filterTableView(ind:Int,text:String) {
        tableView.reloadData()
        switch ind {
        case selectedScope.title.rawValue:
            //fix of not searching when backspacing
            nowPlayingMovie = initialMovie.filter({ (movie) -> Bool in
                return (movie.title?.lowercased().contains(text.lowercased()))!
            })
            self.tableView.reloadData()
        default:
            print("No Type Found!!!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nowPlayingMovie.count
    }
    
    //MARK: - Cell For Row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        
        let movie = nowPlayingMovie[indexPath.row]
        
        cell.lblTitle.text = movie.title
        cell.lblOverview.text = movie.overview
        cell.lblVote.text = String(describing: movie.voteAverage!)
        let baseUrl = "http://image.tmdb.org/t/p/w185"
        
        let imageUrl = URL(string: baseUrl + movie.posterPath!)
        
        cell.imgMovie.sd_setImage(with: imageUrl)
        
        return cell
    }
    
    //MARK: - Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MovieDetail" {
            let movieDetailVC = segue.destination as! MovieDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let movie = nowPlayingMovie[indexPath.row]
                movieDetailVC.movieID = movie.id!
            }
        }
    }
    
    //MARK: - Get Movie
    func getMovies(page: Int?) {
        var queryParams = [URLQueryItem]()
        
        if let page = page {
            queryParams.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        let url = ApiClient.createUrl(queryParams: queryParams)!
        print(url)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: URLRequest(url: url), completionHandler: {
            data, response, error in
            
            self.onFetchMoviesComplete(data, response: response, error: error as NSError?)
        })
        task.resume()
    }
    
    //MARK: - Get now playing movies
    fileprivate func onFetchMoviesComplete(_ data: Data?, response: URLResponse?, error: NSError?) {
        if error != nil {
            print("An error occurred while loading now playing list: \(String(describing: error?.localizedDescription))")
        }
        else {
            if let rawData = data {
                do {
                    //get response
                    let jsonResponse = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String:Any]
                    //parse data
                    self.page = jsonResponse?["page"] as? Int
                    //self.totalPages = jsonResponse?["total_pages"] as? Int
                    //parse results
                    if let moviesJson = jsonResponse?["results"] as? [[String: AnyObject]] {
                        for movieJson in moviesJson {
                            self.initialMovie.append(Movie(parsedJson: movieJson))
                        }
                        self.nowPlayingMovie = initialMovie
                    }
                    
                }
                catch let error as NSError {
                    // Handle JSON parsing error
                    print("\(error.localizedDescription)")
                }
            }
        }
        
        // Refresh table view on the main UI thread
        DispatchQueue.main.async {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }

    //MARK: - Animation for TableView
    func animateTable() {
        
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.85, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
