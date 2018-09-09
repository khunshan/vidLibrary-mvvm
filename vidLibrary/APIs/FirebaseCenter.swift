//
//  FirebaseCenter.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/21/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class FirebaseCenter {
    
    static let sharedInstance = FirebaseCenter()
    
    let uuid = UIDevice.current.identifierForVendor!.uuidString
    var ref: DatabaseReference = Database.database().reference()
    
    //Fetch method for Firebase
    //Param: JSONMapper Object
    //Retrun: Callback with JSONMapper Objects Array
    func fetchSnapshotForFavoriteData<T:JSONMapper>(child:String = Constants.kFavoriteChildFirebaseKey, callback: @escaping (_ :[T]) -> Void) {
        
        ref.child(uuid).child(child).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var jsonMapperArr = [T]()
            
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                //let key = userSnap.key //the key of each movie
                let value = userSnap.value as! String
                
                if let data = value.data(using: .utf8, allowLossyConversion: false) {
                    let jsonMapperObj = T(data: data)
                    jsonMapperArr.append(jsonMapperObj)
                }
            }

            callback(jsonMapperArr)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //Save Favorite Movie
    func saveFavorite(child:String = Constants.kFavoriteChildFirebaseKey, key:String, value: String) {
        ref.child(FirebaseCenter.sharedInstance.uuid).child(child).child(key).setValue(value)
    }
    
    //Delete Favorite Movie
    func deleteFavorite(child:String = Constants.kFavoriteChildFirebaseKey, key:String) {
        ref.child(FirebaseCenter.sharedInstance.uuid).child(child).child(key).setValue(nil)
    }
}
