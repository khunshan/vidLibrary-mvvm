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
 
 Methods prefix convention is
 fetch  -> get
 save   -> post
 update -> put
 delete -> delete
 */

protocol JSONMapper {
    init(data: Any)
}

class DataCenter {

    static func fetchMoviesData(completion: @escaping (Movie?, Error?) -> ()) {
        let urlString = "http://s3.amazonaws.com/vodassets/showcase.json"
        //TBD.. call webservices, fetch into models and response back
        
        
        Alamofire.request(urlString).responseJSON { response in
            switch response.result {
            case .success(let result):
                completion(Movie(data: result), nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}
