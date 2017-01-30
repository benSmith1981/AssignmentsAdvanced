//
//  OMBDListTableViewController.swift
//  UItableJSONSerialisation
//
//  Created by Ben Smith on 19/01/17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

/// <#Description#>
import UIKit
import Kingfisher

class OMBDListTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)

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
    
    let jsonString = "{\"Title\":\"Game of Thrones\",\"Season\":\"1\",\"totalSeasons\":\"8\",\"Episodes\":[{\"Title\":\"Winter Is Coming\",\"Released\":\"2011-04-17\",\"Episode\":\"1\",\"imdbRating\":\"9.0\",\"imdbID\":\"tt1480055\"},{\"Title\":\"The Kingsroad\",\"Released\":\"2011-04-24\",\"Episode\":\"2\",\"imdbRating\":\"8.8\",\"imdbID\":\"tt1668746\"},{\"Title\":\"Lord Snow\",\"Released\":\"2011-05-01\",\"Episode\":\"3\",\"imdbRating\":\"8.6\",\"imdbID\":\"tt1829962\"},{\"Title\":\"Cripples, Bastards, and Broken Things\",\"Released\":\"2011-05-08\",\"Episode\":\"4\",\"imdbRating\":\"8.7\",\"imdbID\":\"tt1829963\"},{\"Title\":\"The Wolf and the Lion\",\"Released\":\"2011-05-15\",\"Episode\":\"5\",\"imdbRating\":\"9.1\",\"imdbID\":\"tt1829964\"},{\"Title\":\"A Golden Crown\",\"Released\":\"2011-05-22\",\"Episode\":\"6\",\"imdbRating\":\"9.1\",\"imdbID\":\"tt1837862\"},{\"Title\":\"You Win or You Die\",\"Released\":\"2011-05-29\",\"Episode\":\"7\",\"imdbRating\":\"9.2\",\"imdbID\":\"tt1837863\"},{\"Title\":\"The Pointy End\",\"Released\":\"2011-06-05\",\"Episode\":\"8\",\"imdbRating\":\"9.0\",\"imdbID\":\"tt1837864\"},{\"Title\":\"Baelor\",\"Released\":\"2011-06-12\",\"Episode\":\"9\",\"imdbRating\":\"9.6\",\"imdbID\":\"tt1851398\"},{\"Title\":\"Fire and Blood\",\"Released\":\"2011-06-19\",\"Episode\":\"10\",\"imdbRating\":\"9.4\",\"imdbID\":\"tt1851397\"}],\"Response\":\"True\"}"

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
        
        OMDBSearchService.sharedInstance.searchOMDBDatabaseByTitle(searchString: "Game of Thrones", page: 1, movieType: movieTypes.series.description) { (success, errorMessage, errorCodeString, movie, movies, totalPages) in
//            MBProgressLoader.Hide()
            
            self.totalPages = totalPages! //force unwrap as we know will be zero or another INT
            
            if success {
                if let movies = movies {
                    self.episodes += movies
                }
            } else {
                
//                MBProgressLoader.Hide()
                if let movie = movie{
                    self.episodes.removeAll()
                    self.episodes.append(movie)
                }
            }
        }
        
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
//        MBProgressLoader.Hide()
        
        if (segue.identifier == "detailView") {
//            MBProgressLoader.Hide()
            // initialize new view controller and cast it as your view controller
//            let detailView = segue.destinationViewController as! OMDBDetailMovieView
//            detailView.movieInfo = self.currentMovieSelected
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if episodes.count >= 0 {
            currentEpisode = episodes[indexPath.row]
            OMDBSearchService.sharedInstance.searchMovieDetailsDatabase(imdbID: (currentEpisode?.imdbID)!, plot: plotTypes.FULL, response: responseTypes.JSON, onCompletion: { (success, errorMessage, errorCode, movie, nil, searchText) in
                
                if success {
                    if let movie = movie {
                        // your new view controller should have property that will store passed value
//                        self.currentMovieSelected = movie
                        self.performSegue(withIdentifier: "detailView", sender: self)
                    }
                } else { //if error returned show the error in the table by adding it to our search results array and displaying that
//                    MBProgressLoader.Hide()
//                    self.searchResultMovies = []
//                    self.searchResultMovies.append(movie!)
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

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: MovieCell = self.tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.setDataForView(movieData: self.episodes[indexPath.row])
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
