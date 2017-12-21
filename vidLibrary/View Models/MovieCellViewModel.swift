//
//  MovieCellViewModel.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/21/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import Foundation

//ViewModel for MovieCell
class MovieCellViewModel {
    
    //MARK: Model Object
    private var movie: Movie?
    
    //MARK: Computed Properties
    var movieTitle: String {
        let title = movie?.headline ?? "--"
        return "Title: " + title
    }
    
    var movieYear : String {
        let year = movie?.year ?? "--"
        return "Year of release: " + year
    }
    
    var movieImageUrl: String? {
        return movie?.keyArtImages?[0].url
    }
    
    var movieDetails: String {
        return movie?.synopsis ?? "No Details"
    }
    
    //MARK: Init
    init(movie: Movie?) {
        self.movie = movie
    }
}
