//
//  MovieModel.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/21/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftyJSON

//Fetchable protocol is useful for such ViewModels that are compose of Collection model data..
protocol Fetchable {
    func fetch<T>(at: Int) -> T?
}


//ViewModel for Movies
class MovieViewModel: Fetchable {
    
    //MARK: Model Object
    private var movies: [Movie]?
    
    //MARK: Computed Properties
    var moviesCount: Int? {
        return movies?.count
    }
    
    //MARK: Sort
    func sortMovies(sortBy: (Movie, Movie) -> Bool, callback: @escaping () -> Void) {
        
        let temp = movies?.sorted(by: sortBy)
        movies = temp
        callback()
    }
    
    //MARK: Fetchable Protocol
    func fetch<Movie>(at: Int) -> Movie? {
        if let count = movies?.count, at < count { //Safety check while scrolling tableview, segment change, indexnotfound
            return movies?[at] as? Movie
        }
        return nil
    }
}

//MARK: Data Center calls
extension MovieViewModel {
    
    func fetchServerData(callback: @escaping () -> Void) {
        
        self.movies?.removeAll()
        
        DataCenter.fetchMoviesData { (moviesArray:[Movie]?, error:Error?) in
            print("response fetched")
            self.movies = moviesArray
            callback()
        }
    }
    
    //Favorite Data
    func fetchFavoriteData(callback: @escaping () -> Void) {
        
        self.movies?.removeAll()
        
        FirebaseCenter.sharedInstance.fetchSnapshotForFavoriteData(
            callback: { (moviesArr:[Movie]) in
                self.movies = moviesArr
                callback()
        })
        
    }
}
