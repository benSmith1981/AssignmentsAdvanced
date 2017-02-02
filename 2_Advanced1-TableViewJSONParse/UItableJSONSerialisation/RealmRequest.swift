//
//  RealmRequest.swift
//  OMDB
//
//  Created by Ivo  Nederlof on 02-02-17.
//  Copyright © 2017 Dutch Melon. All rights reserved.
//

import Foundation
import RealmSwift

class RealmRequest {
    
    static let sharedInstance = RealmRequest()
    private init() {}
    
    func getMovieHistory() -> Results<Search> {
        let realm = try! Realm()
        return realm.objects(Search.self)
    }
}
