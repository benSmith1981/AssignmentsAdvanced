//
//  RealmDeleteService.swift
//  OMDB
//
//  Created by Ivo  Nederlof on 07-02-17.
//  Copyright © 2017 Dutch Melon. All rights reserved.
//

import RealmSwift
import Foundation

class RealmDeleteService {
    
    static let sharedInstance = RealmDeleteService()
    private init() { }
    
    /**
     
     DELETE METHOD
     
     - Parameter item: item realm object example -> objects[indexPath.row]
     
     */
    public func deleteSpecificObject(_ item: Object) {
        
        do {
            let realm = try! Realm()
            try! realm.write{
                realm.delete(item)
            }
        } catch let error as NSError {
            print(error)
        }
    }
}
