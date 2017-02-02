//
//  RealmWrite.swift
//  OMDB
//
//  Created by Ivo  Nederlof on 02-02-17.
//  Copyright © 2017 Dutch Melon. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWrite {
    
    static let sharedInstance = RealmWrite()
    
    private var overTotalHistory : Bool = false
    
    private init() {}
    
    
    
    private func checkIfAlreadyExist() {
    
    }
    
    private func checkIfExtends(_ i: Int, max:Int) -> Bool {
        
        if i < max {
            overTotalHistory = true
        }
        return overTotalHistory
    }
    
    
    
    /// Writes the movie to coredata, for visual table when opening app
    ///
    /// - Parameters:
    ///   - title: The main movie/serie title
    ///   - imdbID: imdb id for checking
    ///   - poster: the poster url for getting the
    public func writeMovieHistory(history: Search) {
        
//        let history = Search.init(dictionary: search)

        do {
            let realm = try Realm(),
                total = realm.objects(Search.self).count
            if checkIfExtends(total, max: 10) {
                try realm.write {
                    realm.add(history)
                }
                print("total in history : \(total)")

            } else {
                print("exceeded max -> Deleted first of array, it has a total of : \(total)")
            }
        } catch {
            print("Realm read write error")
        }


    }
}
