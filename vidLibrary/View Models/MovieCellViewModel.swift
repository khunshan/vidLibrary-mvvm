//
//  MovieCellViewModel.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/21/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

//ViewModel for MovieCell
class MovieCellViewModel {
    
    //MARK: Model Object
    private var movie: Movie?
    
    //MARK: Computed Properties
    var movieTitle: String {
        let title = movie?.headline ?? "Unknown"
        return "Title: " + title
    }
    
    var movieYear : String {
        let year = movie?.year ?? "Unknown"
        return "Year of release: " + year
    }
    
    var movieImageUrl: String? {
        return movie?.keyArtImages?[0].url
    }
    
    var movieDetails: String {
        return movie?.synopsis ?? "No Details Available"
    }
    
    var movieID: String? {
        return movie?.id
    }
    
    //MARK: Init
    init(movie: Movie?) {
        self.movie = movie
    }
    
    //MARK: toJsonString
    func toJson() -> String? {
        
        let dic = movie!.toDictionary()
        
        var jsonString:String?
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: dic, options: []) {
            
            let theJSONText = String(data: theJSONData, encoding: .ascii)
            //print("JSON string = \(theJSONText!)")
            jsonString = theJSONText!
        }
        
        return jsonString
    }
}

//MARK: Data Center calls
extension MovieCellViewModel {
    
    func saveFavorite() {
        print("saving")
        if let jsonString = self.toJson() {
            FirebaseCenter.sharedInstance.saveFavorite(
                child: Constants.kFavoriteChildFirebaseKey,
                key: movieID!, value: jsonString)
        }
    }
    
    func deleteFavorite() {
        print("deleting")
        FirebaseCenter.sharedInstance.deleteFavorite(key: movieID!)
    }
}
