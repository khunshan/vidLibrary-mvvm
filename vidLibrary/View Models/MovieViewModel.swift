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
import Bond

//Fetchable protocol is useful for such ViewModels that are compose of Collection model data..
protocol Fetchable {
    func fetch<T>(at: Int) -> T?
}


//ViewModel for Movies
class MovieViewModel {
    
    //MARK: Model Object
    //private var movies: [Movie]?
    var movies = MutableObservableArray<Movie>([])
    
    
    //MARK: Computed Properties
    var moviesCount: Int? {
        return movies.count
    }
    
    //MARK: Sort
    func sortMovies(sortBy: (Movie, Movie) -> Bool, callback: @escaping () -> Void) {
        
        let temp = movies.array.sorted(by: sortBy)
        movies.removeAll()
        movies.insert(contentsOf: temp, at: 0)
        
        //let temp = movies.sorted(by: sortBy)
        //movies = temp
        callback()
    }
    
}

extension MovieViewModel: Fetchable {
    //MARK: Fetchable Protocol
    func fetch<Movie>(at: Int) -> Movie? {
        let count = movies.count
        if at < count { //Safety check while scrolling tableview, segment change, indexnotfound
            return movies[at] as? Movie
        }
        return nil
    }
}

//MARK: Data Center calls
extension MovieViewModel {
    
    func fetchServerData(callback: @escaping () -> Void) {
        
       // self.movies.removeAll()
        
        DataCenter.fetchMoviesData { (moviesArray:[Movie]?, error:Error?) in
            print("response fetched")
            self.movies.removeAll()
            self.movies.insert(contentsOf: moviesArray ?? [], at: 0)
            callback()
        }
    }
    
    //Favorite Data
    func fetchFavoriteData(callback: @escaping () -> Void) {
        
       // self.movies.removeAll()
        
        FirebaseCenter.sharedInstance.fetchSnapshotForFavoriteData(
            callback: { (moviesArray:[Movie]) in
                print("fav fetched")
                self.movies.removeAll()
                self.movies.insert(contentsOf: moviesArray, at: 0)
                callback()
        })
        
    }
}
