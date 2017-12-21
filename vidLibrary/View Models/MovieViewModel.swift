//
//  MovieModel.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/21/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation


//Fetchable protocol is useful for such ViewModels that are compose of Collection model data..
protocol Fetchable {
    func fetch<T>(at: Int) -> T?
}


//ViewModel for Movies
class MovieViewModel: Fetchable {

    //MARK: Model Object
    var movies: [Movie]?
    
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
        return movies?[at] as? Movie
    }
}

//MARK: Data Center
extension MovieViewModel {
    
    func fetchServerData(callback: @escaping () -> Void) {
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
