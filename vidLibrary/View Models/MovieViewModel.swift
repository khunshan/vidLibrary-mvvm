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
class MovieViewModel {
    
    //MARK: Model Object
    
    /*private*/ var movies = Binder<[Movie]>([])
    
    //MARK: Computed Properties
    var moviesCount: Int? {
        return movies.value.count
    }
    
    //MARK: Sort
    func sortMovies(sortBy: (Movie, Movie) -> Bool, callback: @escaping () -> Void) {
        
        let temp = movies.value.sorted(by: sortBy)
        movies.value = temp
        callback()
    }
    
}

extension MovieViewModel: Fetchable {
    //MARK: Fetchable Protocol
    func fetch<Movie>(at: Int) -> Movie? {
        let count = movies.value.count
        
        if at < count { //Safety check while scrolling tableview, segment change, indexnotfound
            return movies.value[at] as? Movie
        }
        return nil
    }
}

//MARK: Data Center calls
extension MovieViewModel {
    
    func fetchServerData(callback: (() -> Void)? = nil) {
        
        DataCenter.fetchMoviesData { (response:[Movie]?, error:Error?) in
            guard let moviesArray = response else { print("response is nil"); return}
            self.movies.value.removeAll()
            self.movies.value = moviesArray
        }
    }
    
    //Favorite Data
    func fetchFavoriteData(callback: (() -> Void)? = nil) {
        
        FirebaseCenter.sharedInstance.fetchSnapshotForFavoriteData(callback: { (response:[Movie]?) in
            guard let moviesArray = response else { print("response is nil"); return}
            self.movies.value.removeAll()
            self.movies.value = moviesArray
        })
        
    }
}
