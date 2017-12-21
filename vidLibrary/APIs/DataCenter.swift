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


//JSONMapper protocol is useful for Model objects initialized with JSON data to be mapped with properties..
protocol JSONMapper {
    init(data: Any)
    //func toDictionary() -> [String:Any]
}

extension JSONMapper {
    func toDictionary() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            
            if let key = child.label {
                
                if let value = child.value as? String {
                    dict[key] = value
                }
                else if let value = child.value as? Int {
                    dict[key] = value
                }
                else if let value = child.value as? [JSONMapper] {
                    var arr = [Any]()
                    for v in value {
                        arr.append(v.toDictionary())
                    }
                    dict[key] = arr
                }
                else if let value = child.value as? JSONMapper {
                    let v = value.toDictionary()
                    dict[key] = v
                }
//                else {
//                    dict[key] = ""
//                }
            }
        }
        return dict
    }
}


//DataCenter to handle web API calls and populate models
/*
 prefix convention:
 fetch  -> get
 save   -> post
 update -> put
 delete -> delete
 */
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
