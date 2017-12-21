//
//  MovieModel.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/21/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation

class MovieModel {

    var movies: [Movie]?
    
    var moviesCount: Int? {
        return movies?.count
    }
    
    //MARK: Sort
    func sortMovies(sortBy: (Movie, Movie) -> Bool, callback: @escaping () -> Void) {
        
        let temp = movies?.sorted(by: sortBy)
        movies = temp
    }
}

//MARK: Data Center
extension MovieModel {
    
    func fetchServerData(callback: @escaping @autoclosure () -> Void) {
        DataCenter.fetchMoviesData { (moviesArray:[Movie]?, error:Error?) in
            print("response fetched")
            self.movies = moviesArray
            callback()
        }
    }
    
    func fetchFavoriteData(callback: @escaping @autoclosure () -> Void) {
        
        self.movies = nil
        callback()
    }
}
