//
//  OMDBSearchService.swift
//  OMDBMovies
//
//  Created by Ben Smith on 07/05/16.
//  Copyright © 2016 Ben Smith. All rights reserved.
//

import Foundation

class OMDBSearchService {
    
    var totalResults:String? //total search results
    var totalPages: Int = 0 // total pages calculated from total results
    let APIService = APIServiceManager.sharedInstance //Shorter common call
    static let sharedInstance = OMDBSearchService()
    
    private init() {}
    
    /** Generic function that contains commmonly used code to deal with the response from the APIService layer, so that the UI can have a nice movie object(s) and user friendly error messages
     - parameter path: String, 
     - parameter searchString: String, 
     - parameter onCompletion: APIMovieResponse
     */
    func searchMovieGeneric(path: String, onCompletion: @escaping APIMovieResponse){
        APIService.callRequestWithAPIServiceResponse(body: nil, path: path, httpMethod: httpMethods.GET, onCompletion: { (success, jsonResponse, error) in
            if success {
                //we get a response array
                //This is specific to the feed Search and totalResults lets me navigate my json
                if let jsonResponseArray = jsonResponse![serverResponseKeys.Search.description] as? NSArray,
                    let totalResults = jsonResponse![serverResponseKeys.totalResults.description] as? String{
                    
                    //Calculate total pages by looking at the remainder of the division
                    self.totalPages = Int(totalResults)!%OMDBConstants.pagesPerRequest != 0 ? Int(totalResults)!/OMDBConstants.pagesPerRequest + 1 : Int(totalResults)!/OMDBConstants.pagesPerRequest
                    
                    var searchResultsArray = [Episode]()
                    searchResultsArray = Episode.modelsFromDictionaryArray(array: jsonResponseArray)
                    
//                    for searchResult in jsonResponseArray{
//                        if let searchResult = searchResult as? BodyDataDictionary {
//                            //parse and store json response
//                            let omdbSearchResponse = Episode.init(dictionary: searchResult as NSDictionary)
//                            searchResultsArray.append(omdbSearchResponse!)
//                        }
//                    }
                    
                    //return the array of movie results
                    onCompletion(success, error?.userInfo[NSLocalizedDescriptionKey] as? String, self.APIService.getErrorCodeDescription(error: error), nil, searchResultsArray, self.totalPages )
                    
                }
                //To handle the case if we get the Dictionary OBject not an array
                if let jsonResponseObject = jsonResponse {
                    //parse and store json response
                    let omdbSearchResponse = Episode.init(dictionary: jsonResponseObject as NSDictionary)
                    //return the movie object
                    onCompletion(success, error?.userInfo[NSLocalizedDescriptionKey] as? String, self.APIService.getErrorCodeDescription(error: error), omdbSearchResponse, nil, self.totalPages )
                    
                    
                }
            } else { //the request failed return the error
                if let jsonResponseObject = jsonResponse { //sometimes json response is an error message
                    //send back a movie object so the errors are displayed nicely on the table
                    let omdbSearchResponse = Episode.init(dictionary: jsonResponseObject as NSDictionary)
                    onCompletion(false, error?.userInfo[NSLocalizedDescriptionKey] as? String, self.APIService.getErrorCodeDescription(error: error), omdbSearchResponse, nil, self.totalPages )
                } else { //sometimes you have to decode it!
                    //send back a movie object so the errors are displayed nicely on the table
                    if let error = error {
                        if let errorDescription = error.userInfo["NSDebugDescription"] {
                            let omdbSearchResponse = Episode.init(dictionary: [serverResponseKeys.Response.description : errorDescription , serverResponseKeys.Error.description : self.APIService.getErrorCodeDescription(error: error)])
                            onCompletion(false, error.userInfo[NSLocalizedDescriptionKey] as? String, self.APIService.getErrorCodeDescription(error: error), omdbSearchResponse, nil, self.totalPages )
                        } else {
                            //no localised description but we have an NSError
                            let omdbSearchResponse = Episode.init(dictionary: [serverResponseKeys.Response.description : "None" , serverResponseKeys.Error.description : self.APIService.getErrorCodeDescription(error: error)])
                            onCompletion(false, "Error Description Unknown", self.APIService.getErrorCodeDescription(error: error), omdbSearchResponse, nil, self.totalPages )
                        }
                    } else { //Unknown Error Case (can use switch here!?)
                        let omdbSearchResponse = Episode.init(dictionary: [serverResponseKeys.Response.description : "None" , serverResponseKeys.Error.description : self.APIService.getErrorCodeDescription(error: nil)])
                        onCompletion(false, "Error Unknown", "Error Code Unknown", omdbSearchResponse, nil, self.totalPages )
                    }

                }
            }
        })
    }
    
    /**
     Searches the movie database for specific details of a movie that the user selects in the table
     http://www.omdbapi.com/?t=12&y=&plot=short&r=json
     - parameter searchString: String The string searched for, stored with the result
     - parameter year: String Year of the movie
     - parameter plot: plotTypes FULL or SHORT plottype so we can display lots or some text to the user
     - parameter response: responseTypes Do we want a JSON or an XML response
     - parameter onCompletion: APIMovieResponse the UI friendly response block with messages and codes and data
     */
    func searchMovieDetailsDatabase(imdbID: String, plot: plotTypes, response: responseTypes, onCompletion: @escaping APIMovieResponse) {
        //example path http://www.omdbapi.com/?t=12&y=&plot=short&r=json
        let path = OMDBConstants.baseUrls.omdbPath + OMDBConstants.parameters.imdbID + "=" + imdbID + "&" + OMDBConstants.parameters.plot + "=" + plot.description +  "&" + OMDBConstants.parameters.responseDataType + "=" + response.description + "&" + OMDBConstants.parameters.tomatoes + "=true"
        
        searchMovieGeneric(path: path, onCompletion: onCompletion)
    }
    
    /**
     Searches the movie database for a movie with a given name returning a list of results
     example path http://www.omdbapi.com/?s=jaws&page=1
     - parameter searchString: String The string searched for, stored with the result
     - parameter page: There maybe multiple pages of results so get what ever page specified
     - parameter movieType: this is the scope type (movie, episode or series) so used can search more specifially
     - parameter onCompletion: APIMovieResponse the UI friendly response block with messages and codes and data
     */
    func searchOMDBDatabaseByTitle(searchString: String, page: Int, movieType: String, onCompletion: @escaping APIMovieResponse) {
        //example path http://www.omdbapi.com/?s=jaws&page=1
        let path: String
        //if we have selected all then don't include scope type
        if (movieType == movieTypes.all.description){
            path = OMDBConstants.baseUrls.omdbPath + OMDBConstants.parameters.searchTitle + "=" + searchString + "&" + OMDBConstants.parameters.page + "=" + String(page)
        } else {
            path = OMDBConstants.baseUrls.omdbPath + OMDBConstants.parameters.searchTitle + "=" + searchString + "&" + OMDBConstants.parameters.page + "=" + String(page) + "&" + OMDBConstants.parameters.movieType + "=" + movieType
        }

        searchMovieGeneric(path: path, onCompletion: onCompletion)
    }

}
