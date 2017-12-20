//
//  Movie.swift
//  vidLibrary
//
//  Created by Khunshan Ahmad on 12/20/17.
//  Copyright © 2017 Khunshan Ahmad. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: JSONMapper {
    
    let skyGoUrl            :String?
    let url                 :String?
    let reviewAuthor        :String?
    let id                  :String?
    let cert                :String?
    let viewingWindow       :ViewingWindow?
    let headline            :String?
    let cardImages          :[String]?
    let directors           :[String]?
    let sum                 :String?
    let keyArtImages        :[String]?
    let synopsis            :String?
    let body                :String?
    let cast                :[String]?
    let skyGold             :String?
    let year                :String?
    let duration            :Int?
    let rating              :Int?
    let class_              :String?
    
    let galleries           :[String]?
    let videos              :[String]?
    let genres              :[String]?

    let quote               :String?

    required init(data: Any) {
        let json            = JSON(data)
        skyGoUrl            = json["skyGoUrl"].string
        url                 = json["url"].string
        reviewAuthor        = json["reviewAuthor"].string
        id                  = json["id"].string
        cert                = json["cert"].string
        viewingWindow       = ViewingWindow(data: json["viewingWindow"])
        headline            = json["headline"].string
        cardImages          = ["TBD"] // json["cardImages"].arrayObject as? [String]
        directors           = ["TBD"] // json["directors"].arrayObject as? [String]
        sum                 = json["sum"].string
        keyArtImages        = ["TBD"] //json["keyArtImages"].arrayObject as? [String]
        synopsis            = json["synopsis"].string
        body                = json["body"].string
        cast                = ["TBD"] //json["cast"].arrayObject as? [String]
        skyGold             = json["skyGold"].string
        year                = json["year"].string
        duration            = json["duration"].int
        rating              = json["rating"].int
        class_              = json["class"].string
        
        galleries           = ["TBD"] //
        videos              = ["TBD"] //json
        genres              = json["genres"].arrayObject as? [String]
        
        quote               = json["quote"].string
    }
}

class ViewingWindow: JSONMapper {
    
    let startDate           : String?
    let wayToWatch          : String?
    
    required init(data: Any) {
        let json            = JSON(data)
        startDate           = json["startDate"].string
        wayToWatch          = json["wayToWatch"].string

    }
}
