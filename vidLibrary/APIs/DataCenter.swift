//
//  DataCenter.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

/*
 DataCenter Class. For calling APIs and populating models.
 
 prefix convention:
  fetch  -> get
  save   -> post
  update -> put
  delete -> delete
 */

protocol JSONMapper {
    init(data: Any)
}

class DataCenter {

    static func fetchMoviesData(completion: @escaping ([Movie]?, Error?) -> ()) {

        let urlString = "http://s3.amazonaws.com/vodassets/showcase.json"
        
        Alamofire.request(urlString).responseJSON { response in
            switch response.result {
                
            case .success(let result):
                
                var movies: [Movie] = []
                
                if let moviesArray = JSON(result).to(type: Movie.self) {
                    movies = moviesArray as! [Movie]
                }
                
                completion(movies, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
