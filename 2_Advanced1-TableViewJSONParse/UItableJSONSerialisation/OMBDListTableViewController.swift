//
//  OMBDListTableViewController.swift
//  UItableJSONSerialisation
//
//  Created by Ben Smith on 19/01/17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

/// Description
import UIKit
import Kingfisher
import MBProgressHUD

class OMBDListTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)

    var detailMovie: DetailObject?

    var currentEpisode: Search?
    var totalPages: Int = 0 //total pages returned from server
    
    //MARK: paging variables for scroll down
    var selectedScope: Int = 0 // the scope currently selected (movie, series, episode_
    var currentPage: Int = 1 //current page we are scrolling on
    var currentSearchText: String = "" //current page we are scrolling on
    
    var episodes = [Search]() {
        didSet{
            //everytime savedarticles is added to or deleted from table is refreshed
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "MovieCell")
        
        searchController.accessibilityLabel = "search"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        //setup the scopes to search between
        searchController.searchBar.scopeButtonTitles = [movieTypesTitles.all.description,
                                                        movieTypesTitles.episode.description,
                                                        movieTypesTitles.movie.description,
                                                        movieTypesTitles.series.description]
        searchController.searchBar.delegate = self
        
//        OMDBSearchService.sharedInstance.searchOMDBDatabaseByTitle(searchString: "Game of Thrones", page: 1, movieType: movieTypes.series.description) { (success, errorMessage, errorCodeString, movie, movies, totalPages) in
////            MBProgressLoader.Hide()
//            
//            self.totalPages = totalPages! //force unwrap as we know will be zero or another INT
//            
//            if success {
//                if let movies = movies {
//                    self.episodes += movies
//                }
//            } else {
//                
////                MBProgressLoader.Hide()
//                if let movie = movie{
//                    self.episodes.removeAll()
//                    self.episodes.append(movie)
//                }
//            }
//        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        OMDBSearchService.sharedInstance.searchMovieDetailsDatabase(imdbID: "", plot: plotTypes.FULL, response: .JSON) { (success, error, code, search, searchesArray, totalResults) in
//            self.performSegue(withIdentifier: "detailView", sender: self)
        }
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        
        if (segue.identifier == "detailView") {
            // initialize new view controller and cast it as your view controller
            let detailView = segue.destination as! DetailViewController
            detailView.detailMovieObject = self.detailMovie
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if episodes.count >= 0 {
            currentEpisode = episodes[indexPath.row]
            OMDBSearchService.sharedInstance.searchMovieDetailsDatabase(imdbID: (currentEpisode?.imdbID)!,
                                                                        plot: plotTypes.FULL,
                                                                        response: responseTypes.JSON,
                                                                        onCompletion: { (
                                                                                success,
                                                                                errorMessage,
                                                                                errorCode,
                                                                                movie,
                                                                                nil,
                                                                                searchText) in
                
                if success {
                    if let movie = movie {
                        // your new view controller should have property that will store passed value
                        self.detailMovie = movie
                        self.performSegue(withIdentifier: "detailView", sender: self)
                    }
                } else {
                    //if error returned show the error in the table by adding it to our search results array and displaying that
                    self.episodes = []
                }
            })

        }
        
    }

}

extension OMBDListTableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: MovieCell = self.tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.setDataForView(movieData: self.episodes[indexPath.row])
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //only load more results if the search is still active
        if searchController.isActive {
            //if we are at the last index of the current table size AND current page is less than total pages then load more results, else don't do anything of course because we got to the end of our results
            if indexPath.row == self.currentPage * OMDBConstants.pagesPerRequest - 1 && self.currentPage < self.totalPages {
                self.currentPage += 1
                if let text = (searchController.searchBar.text) { //check for nil search text then search for more movies that are conatined in the response but not yet paged
                    let scope = determineScope(scopeTitle: searchController.searchBar.scopeButtonTitles![selectedScope])
                    self.doSearch(searchString: text, page: self.currentPage, movieTypeScope: scope)
                }
            }
        }
    }
}
