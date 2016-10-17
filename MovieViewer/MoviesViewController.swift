//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Shola Oyedele on 10/12/16.
//  Copyright © 2016 Jennifer Shola. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController!
    var filteredData: [NSDictionary]!
    
    var refreshControl: UIRefreshControl!
    var movies: [NSDictionary]?
    var endpoint:String = "now_playing"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    
                    self.movies = responseDictionary.value(forKey: "results") as? [NSDictionary]
                    self.filteredData = self.movies
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    
                    self.movies = responseDictionary.value(forKey: "results") as? [NSDictionary]
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                }
            }
        });

        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredData = filteredData {
            return filteredData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredData![(indexPath as NSIndexPath).row]
        let title = movie.value(forKey: "title") as! String
        let overview = movie.value(forKey: "overview") as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if let posterPath = movie.value(forKey: "poster_path") as? String {
            let posterURL = URL(string: baseUrl + posterPath)
            cell.posterView.setImageWith(posterURL!)
        }
        
        return cell
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![(indexPath! as NSIndexPath).row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? movies : movies!.filter({(movie: NSDictionary) -> Bool in
                let movie_title = movie.value(forKey: "title") as? String
                return movie_title!.range(of: searchText) != nil
                
            })
            
            tableView.reloadData()
        }
    }
    
}







