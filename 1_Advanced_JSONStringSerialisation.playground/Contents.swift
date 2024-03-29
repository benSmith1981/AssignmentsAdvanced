//: Playground - noun: a place where people can play

import UIKit

//JSON SERIALISATION
let jsonString = "{\"Title\":\"Game of Thrones\",\"Season\":\"1\",\"totalSeasons\":\"8\",\"Episodes\":[{\"Title\":\"Winter Is Coming\",\"Released\":\"2011-04-17\",\"Episode\":\"1\",\"imdbRating\":\"9.0\",\"imdbID\":\"tt1480055\"},{\"Title\":\"The Kingsroad\",\"Released\":\"2011-04-24\",\"Episode\":\"2\",\"imdbRating\":\"8.8\",\"imdbID\":\"tt1668746\"},{\"Title\":\"Lord Snow\",\"Released\":\"2011-05-01\",\"Episode\":\"3\",\"imdbRating\":\"8.6\",\"imdbID\":\"tt1829962\"},{\"Title\":\"Cripples, Bastards, and Broken Things\",\"Released\":\"2011-05-08\",\"Episode\":\"4\",\"imdbRating\":\"8.7\",\"imdbID\":\"tt1829963\"},{\"Title\":\"The Wolf and the Lion\",\"Released\":\"2011-05-15\",\"Episode\":\"5\",\"imdbRating\":\"9.1\",\"imdbID\":\"tt1829964\"},{\"Title\":\"A Golden Crown\",\"Released\":\"2011-05-22\",\"Episode\":\"6\",\"imdbRating\":\"9.1\",\"imdbID\":\"tt1837862\"},{\"Title\":\"You Win or You Die\",\"Released\":\"2011-05-29\",\"Episode\":\"7\",\"imdbRating\":\"9.2\",\"imdbID\":\"tt1837863\"},{\"Title\":\"The Pointy End\",\"Released\":\"2011-06-05\",\"Episode\":\"8\",\"imdbRating\":\"9.0\",\"imdbID\":\"tt1837864\"},{\"Title\":\"Baelor\",\"Released\":\"2011-06-12\",\"Episode\":\"9\",\"imdbRating\":\"9.6\",\"imdbID\":\"tt1851398\"},{\"Title\":\"Fire and Blood\",\"Released\":\"2011-06-19\",\"Episode\":\"10\",\"imdbRating\":\"9.4\",\"imdbID\":\"tt1851397\"}],\"Response\":\"True\"}"


extension String {
    
    var parseJSONString: AnyObject? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            do {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                return message as AnyObject?
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
            
            // Will return an object or nil if JSON decoding fails
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}

let json: AnyObject? = jsonString.parseJSONString


if let episodesDict = json as? NSDictionary,
    let episodes = episodesDict["Episodes"] {
    for currentEpisode in (episodes as? NSArray)!{
        if let episode = (currentEpisode as? NSDictionary),
            let title = episode["Title"]{
            print(title)
        }
    }
}
